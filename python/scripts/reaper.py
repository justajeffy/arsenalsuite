#!/usr/bin/python

from PyQt4.QtCore import *
from PyQt4.QtSql import *
from blur.Stone import *
from blur.Classes import *
import blur.email, blur.jabber
import sys, time, re, os
from math import ceil
import traceback

try:
	import popen2
except: pass

if sys.argv.count('-daemonize'):
	from blur.daemonize import createDaemon
	createDaemon()

reaperConfig = '/etc/reaper.ini'
try:
	pos = sys.argv.index('-config')
	reaperConfig = sys.argv[pos+1]
except: pass
dbConfig = '/etc/db.ini'
try:
	pos = sys.argv.index('-dbconfig')
	dbConfig = sys.argv[pos+1]
except: pass

app = QCoreApplication(sys.argv)

initConfig( reaperConfig, "/var/log/ab/reaper.log" )
# Read values from db.ini, but dont overwrite values from reaper.ini
# This allows db.ini defaults to work even if reaper.ini is non-existent
config().readFromFile( dbConfig, False )

blur.RedirectOutputToLog()

initStone( sys.argv )

classes_loader()

VERBOSE_DEBUG = False

if VERBOSE_DEBUG:
	Database.current().setEchoMode( Database.EchoUpdate | Database.EchoDelete | Database.EchoSelect )

Database.current().connection().reconnect()

# Stores/Updates Config vars needed for reaper
class ReaperConfig:
	def update(self):
		self.managerDriveLetter = str(Config.getString('managerDriveLetter')).lower()
		self.spoolDir = Config.getString('managerSpoolDir')
		self.requiredSpoolSpacePercent = Config.getFloat('assburnerRequiredSpoolSpacePercent',10.0)
		self.totalFailureThreshold = Config.getInt('assburnerTotalFailureErrorThreshold',30)
		self.permissableMapDrives = Config.getString('assburnerPermissableMapDrives','G:,V:')
		self.assburnerForkJobVerify = Config.getBool('assburnerForkJobVerify',True)
		self.jabberDomain = Config.getString('jabberDomain','jabber.com')
		self.jabberSystemUser = Config.getString('jabberSystemUser','farm')
		self.jabberSystemPassword = Config.getString('jabberSystemPassword','farm')
		self.jabberSystemResource = Config.getString('jabberSystemResource','Reaper')

def execReturnStdout(cmd):
	p = popen2.Popen3(cmd)
	while True:
		try:
			p.wait()
			break
		except OSError:
			print 'EINTR during popen2.wait, ignoring.'
			pass
	return p.fromchild.read()

def getLocalFilePath(job):
	if config.spoolDir != "":
		baseName = QFileInfo(job.fileName()).fileName()
		userName = job.user().name()
		userDir = config.spoolDir + "/" + userName + "/"
		filePath = userDir + baseName
		return str(filePath)
	else: return str(job.fileName())

def cleanupJob(job):
	print "cleanupJob called on %s jobID: %i" % (job.name(), job.key())
	if not job.user().isRecord():
		print "Job::cleanup cannot clean up a job that isn't assigned a user!\n"
		return

	if job.uploadedFile():
		filePath = getLocalFilePath(job)
		filePathExtra = re.sub('(\.zip|\.max)','.txt',filePath)

		if config.spoolDir != "":
			QFile.remove(filePath)
			QFile.remove(filePathExtra)

def diskFree(path):
	if len(path) < 1:
		path = '/'
	dfcmd = '/bin/df'
	inp = []
	for line in execReturnStdout('%s %s 2>&1' % (dfcmd, path)).splitlines():
		line = line.strip()
		if line.find('Filesystem') >= 0:
			continue
		inp.append(line)
	parts = re.split('\s+',' '.join(inp))
	device, blocks, usedblocks, freeblocks, percent_used, mountpoint = parts
	percent_used = int(re.sub('\%','',percent_used))
	return (blocks,usedblocks,freeblocks,percent_used)

# Usage: checkSpoolSpace( SpoolDir, RequiredPercent )
# Returns: 1 for sufficient space, else 0
def checkSpoolSpace(requiredPercent):
	(blocks,usedblocks,freeblocks,percent_used) = diskFree(config.spoolDir)
	if (100 - percent_used) >= requiredPercent: return True
	print "checkSpoolSpace found required percent free disk space on %s insufficient (%i %% used)!" % (config.spoolDir, percent_used)
	return False

def cleanupJobs():
	if VERBOSE_DEBUG: print "cleanupJobs called, retrieving cleanable jobs"
	jobsCleaned = 0
	for job in retrieveCleanable():
		print "Found cleanable Job: %s %i" % (job.name(), job.key() )
		cleanupJob(job)
		job.setCleaned(True)
		job.commit()
		jobsCleaned+=1
	if VERBOSE_DEBUG: print "Job::cleanupJobs done, returning,", jobsCleaned
	return jobsCleaned

def ensureSpoolSpace(requiredPercent):
	triedCleanup = False
	while not checkSpoolSpace( requiredPercent ):
		print "ensureSpoolSpace -- checkSpool indicates not enough free space, attemping to free space!"
		if not triedCleanup:
			triedCleanup = True
			if cleanupJobs() > 0:
				continue
		jobs = Job.select("fkeyjobtype=9 and status='done' ORDER BY endedts asc limit 1")
		#only auto-deleting max8 jobs for now, some batch jobs will be really old and ppl will want them saved 
		#no matter what disk space they use
		if not jobs.isEmpty():
			job = jobs[0]
			print "Setting Job %s to deleted and removing files to free disk space" % (job.name())
			job.setStatus('deleted')
			cleanupJob(job)
			job.setCleaned(True)
			job.commit()
			notifylist = "it:e"
			if job.user().isRecord():
				notifylist += "," + job.user().name() + ":je" 
 			notifySend( notifyList = notifylist, subject = 'Job auto-deleted: ' + job.name(),
						body = "Your old max8 job was automatically deleted to free up space on the Assburner job spool. Job: " + job.name() )
		else:
			print "Failed to ensure proper spool space, no more done jobs to delete and cleanup."
			return False
	return True

def getSlotCount(job):
	q = Database.current().exec_("""
     SELECT fkeyjob, sum(slots) 
     FROM JobAssignment ja
     JOIN job ON ja.fkeyjob = job.keyjob
     WHERE fkeyjob = %i
     AND fkeyjobassignmentstatus 
         IN (SELECT keyjobassignmentstatus FROM jobassignmentstatus WHERE status IN ('ready','copy','busy'))
     GROUP BY fkeyjob""" % job.key())

	if q.next():
		return q.value(1).toInt()[0]
	return 0

def getErrorCount(job):
	q = Database.current().exec_("SELECT sum(count) FROM JobError WHERE cleared=false AND fkeyJob=%i" % (job.key()) )
	if q.next():
		return q.value(0).toInt()[0]
	return 0

def getTimeoutCount(job):
	q = Database.current().exec_("SELECT count(*) FROM JobError WHERE timeout=true AND cleared=false AND fkeyjob=%i GROUP BY fkeyhost" % job.key() )
	if q.next():
		return q.value(0).toInt()[0]
	return 0

def getAvgTaskTime(job):
	q = Database.current().exec_("""SELECT GREATEST(0, 
                                                    AVG( GREATEST(0, 
                                                                  EXTRACT(epoch FROM (coalesce(jobtaskassignment.ended, 
                                                                                               now()
                                                                                     ) - jobtaskassignment.started)
                                                                  ) 
                                                         ) 
                                                    )
                                           )::int 
                                    FROM JobTaskAssignment 
                                    INNER JOIN JobTask ON JobTask.fkeyjobtaskassignment=jobtaskassignment.keyjobtaskassignment 
                                    WHERE fkeyjob=%i 
                                      AND jobtaskassignment.started IS NOT NULL""" % (job.key()))
	if q.next():
		return q.value(0).toInt()[0]
	return 0

def getAvgMemory(job):
	q = Database.current().exec_("""SELECT AVG( jobtaskassignment.memory )::int 
                                    FROM JobTaskAssignment 
                                    INNER JOIN JobTask ON JobTask.fkeyjobtaskassignment=jobtaskassignment.keyjobtaskassignment 
                                    WHERE jobtask.fkeyjob=%i 
                                    AND jobtaskassignment.memory IS NOT NULL 
                                    AND jobtaskassignment.memory > 0""" % (job.key()))
	if q.next():
		return q.value(0).toInt()[0]
	return 0
	
def retrieveReapable():
	jobList = Job.select("status IN ('ready','started')")
	if not jobList.isEmpty():
		JobStatus.select("fkeyjob IN ("+jobList.keyString()+")")
	return jobList

def retrieveCleanable():
	return Job.select("status IN ('deleted') AND (cleaned IS NULL OR cleaned=0)")

def reaper():
    #	Config: managerDriveLetter, managerSpoolDir, assburnerErrorStep
    print "Reaper is starting up"

    errorStep = Config.getInt('assburnerErrorStep')

    # Make sure that people get notified at most once per error
    if not errorStep or errorStep < 1:
        errorStep = 1

    while True:
        service.pulse()
        config.update()
        if config.spoolDir != "":
            ensureSpoolSpace(config.requiredSpoolSpacePercent)

        for job in retrieveReapable():
            if VERBOSE_DEBUG: print "Checking Job %i %s" % (job.key(), job.name())
            status = str(job.status())

            Database.current().exec_('SELECT update_job_links(%i)' % job.key())

            Database.current().exec_("SELECT update_job_task_counts(%i)" % job.key())
            js = JobStatus.recordByJob(job)
            unassigned  = js.tasksUnassigned()
            done        = js.tasksDone()
            tasks       = js.tasksCount()
            cancelled   = js.tasksCancelled()
            assigned    = js.tasksAssigned()
            busy        = js.tasksBusy()

            hostCount = getSlotCount(job)
            #print "host has %s slots active" % hostCount

            js.setHostsOnJob(hostCount)

            errorCount = getErrorCount(job)
            js.setErrorCount(errorCount)

            suspend = False
            suspendTitle = ''
            suspendMsg = ''
            if errorCount > 3:
                timeoutCount = getTimeoutCount(job)
                if timeoutCount > 3:
                    suspend = True
                    suspendMsg = 'Job %s has been suspended.  The job has timed out on %i hosts.' % (job.name(),timeoutCount)
                    suspendTitle = 'Job %s has been suspended(Timeout limit reached).' % job.name()

            q = Database.current().exec_('SELECT update_job_stats(%i)' % job.key())

            # If job is erroring check job and global error thresholds
            if errorCount > job.maxErrors() or (done == 0 and errorCount > config.totalFailureThreshold):
                suspend = True
                suspendMsg = 'Job %s has been suspended.  The job has produced %i errors.' % (job.name(),errorCount)
                suspendTitle = 'Job %s suspended.' % job.name()

            if suspend:
                # Return tasks and hosts
                Job.updateJobStatuses( JobList(job), 'suspended', False )
                notifyList = str(job.notifyOnError())
                # If they don't have notifications on for job errors, then
                # notify them via email and jabber
                if len(notifyList) == 0:
                    notifyList = job.user().name() + ':je'
                notifySend(notifyList, suspendMsg, suspendTitle )
                continue

            # send error notifications
            lastErrorCount = js.lastNotifiedErrorCount()

            # If some or all of the errors were cleared
            if errorCount < lastErrorCount:
                js.setLastNotifiedErrorCount( errorCount )

            # Notify about errors if needed
            if job.notifyOnError() and errorCount - lastErrorCount > errorStep:
                notifyOnErrorSend(job,errorCount)
                js.setLastNotifiedErrorCount( errorCount )

            # now we set the status started unless it's new
            if busy + assigned > 0:
                if job.status() == 'ready':
                    job.setStatus('started')
                if job.startedts().isNull():
                    job.setColumnLiteral( "startedts", "now()" )

            # done if no more tasks
            if done + cancelled >= tasks:
                job.setColumnLiteral("endedts","now()")
                if job.notifyOnComplete():
                    notifyOnCompleteSend(job)
                if job.deleteOnComplete():
                    job.setStatus( 'deleted' )
                else:
                    job.setStatus( 'done' )

                job.commit()
                # go through every job that is waiting on this one to finish
                # then if that job has other dependencies, make sure they are complete
                # too. If so then it is good to go.
                Database.current().exec_('SELECT update_job_hard_deps(%i)' % job.key())

            job.commit()
            js.commit()

        cleanupJobs()

        if VERBOSE_DEBUG: print "Sleeping for 3 seconds"
        time.sleep(3)

def notifyOnCompleteSend(job):
    if VERBOSE_DEBUG:
        print 'notifyOnCompleteSend(): Job %s is complete.' % (job.name())
    msg = 'Job %s is complete.' % (job.name())
    if not job.notifyCompleteMessage().isEmpty():
        msg = job.notifyCompleteMessage()
    notifySend( notifyList = job.notifyOnComplete(), subject = msg, body = msg )

def notifyOnErrorSend(job,errorCount):
    if VERBOSE_DEBUG:
        print 'notifyOnErrorSend(): Job %s has errors.' % (job.name())
    msg = 'Job %s (%i) for user %s has %i errors.' % (job.name(), job.key(), job.user().name(), errorCount)
    if not job.notifyErrorMessage().isEmpty():
        msg = job.notifyErrorMessage()
    notifySend( notifyList = job.notifyOnError(), body = msg, subject = msg, noEmail = True )

def notifySend( notifyList, body, subject, noEmail = False ):
	for notify in str(notifyList).split(','):
		try:  # Incorrectly formatted notify entries are skipped
			recipient, method = notify.split(':')
			if 'e' in method and not noEmail:
				blur.email.send(sender = 'thePipe@blur.com', recipients = [recipient], subject = subject, body = body )
			if 'j' in method:
				sender = config.jabberSystemUser +'@'+ config.jabberDomain +'/'+config.jabberSystemResource
				recipient += '@'+config.jabberDomain
				if VERBOSE_DEBUG:
					print 'JABBER: %s %s %s %s\n' % (sender, config.jabberSystemPassword, recipient, body) 
				blur.jabber.send(str(sender), str(config.jabberSystemPassword), str(recipient), str(body) )
		except:
			if VERBOSE_DEBUG:
				print 'bad formatting in notifyList %s\n' % (notifyList)
			pass

config = ReaperConfig()
config.update()

service = Service.ensureServiceExists('AB_Reaper')

# Holds PID of checker:Job
newJobCheckers = {}

reaper()
