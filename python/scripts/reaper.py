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

config = ReaperConfig()
config.update()

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

def checkNewJob(job):
	# make sure the job file exists
	print 'Checking new job %i, %s' % ( job.key(), job.name() )
	
	if not job.user().isRecord():
		print "Job missing fkeyUsr"
		return False

	fileName = str(job.fileName())
	if fileName and len(fileName):
		filePathExtra = ''
			
		if config.spoolDir != "":
			if job.uploadedFile() and not config.managerDriveLetter in fileName.lower():
				print "Job submission not finished, still has local fileName %s" % (job.fileName())
				return False

		if job.checkFileMd5():
			filePath = getLocalFilePath(job)
			filePathExtra = re.sub('(\.zip|\.max)','.txt',filePath)
		
			if not QFile.exists( filePath ):
				print "Job file not found:", filePath
				return False
		
			if filePath in execReturnStdout( 'lsof %s 2>&1' % (filePath) ):
				print "Job file still open:", filePath
				return False
		
			if config.spoolDir != "":
				if not str(job.key()) in filePath:
					print "Job file without job key:", filePath
					return False

			md5sum = execReturnStdout('md5sum ' + filePath)[:32].lower()
	
			if md5sum != str(job.fileMd5sum()).lower():
				print "Job file %s md5sum doesnt match the database local md5sum: %s db md5sum: %s" % (filePath, md5sum, job.fileMd5sum())
				job.setStatus( 'corrupt' )
				cleanupJob(job)
				job.setCleaned(True)
				job.commit()
				host = job.host()
				notifylist = "it:e"
				notifySend( notifyList = notifylist, subject = 'Corrupt jobfile from host ' + host.name(),
							body = "The following host just uploaded a corrupt job file to the Assburner spool.\n"
								+ "Host: %s\nJob: %s\nJobID: %i\n\n" % (host.name(), job.name(), job.key()) )
				return False
		
			job.setFileSize( QFileInfo( filePath ).size() )
	
		# automatically suspend job if assets use UNC paths or if there are 
		# any mapped drives used besides G:\ (ie, job uses assets from K: or S:)
		badpaths, badpaths2 = [], []
		if QFile.exists(filePathExtra):
			file = open(filePathExtra,'r')
			
			try:
				# BLUR SPECIFIC HACK
				# Get mappings for G, should be 0 or 1
				gMappings = job.jobType().jobTypeMappings().mappings().filter( "mount", QRegExp("g",Qt.CaseInsensitive) )
				# If we have a G mapping and it's a mirror(uses hostmapping instead of fkeyhost for multiple mirrors)
				usingGMirror = (gMappings.size() == 1 and not gMappings[0].host().isRecord())
				validGPathRegs = []
				if usingGMirror:
					validGPathRegs.append( QRegExp( "/_master/", Qt.CaseInsensitive ) )
					validGPathRegs.append( QRegExp( "/maps/", Qt.CaseInsensitive ) )
					validGPathRegs.append( QRegExp( "/(?:050_)maps/", Qt.CaseInsensitive ) )
					validGPathRegs.append( QRegExp( "/Texture/" ) )
					validGPathRegs.append( QRegExp( "/(?:050_)maps/", Qt.CaseInsensitive ) )
					validGPathRegs.append( QRegExp( "/read/" ) )
			
								#rsync -W --numeric-ids -av --progress --stats --timeout=900 --delete 
								#--dry-run --include '*/' --exclude '*.[Pp][Ss][Dd]' --exclude 'temp/' 
								#--include '*.rps' --include '*_MASTER.max' --include '*.flw' --include 
								#'**/_MASTER/**' --include' **/_Master/**' --include 
								#'**/[Mm][Aa][Pp][Ss]/**' --include '**/050_maps/ **' --include 
								#'**/Texture/**' --include '**/read/*pc2' --include '**/read/*tmc' 
								#--include '**/read/*mdd' --include '**/Mesh*bin' --exclude '*' 
			except:
				print "Exception while setting up regexs for valid g maps mirror path tests"
				traceback.print_exc()
			
			for line in file:
				line = line.strip()
				if re.match('\#',line): continue
				if re.match('mem',line): continue
				if re.match('(map|pc|file)',line):
					try:
						# Format per line is
						# filetype,refcount,size,path
						# Because path can contain commas, we set maxsplit to 3, to avoid splitting path
						filetype, refcount, size, path = line.split(',',3)
						if re.match('(\\\\|\/\/)',path,re.I):
							badpaths.append(path)
						# Create a RE from the paths, in the format (G:|V:)
						mapDriveRe = '(%s)' % ('|'.join( [str(s) for s in config.permissableMapDrives.split(',') ] ) )
						if re.match('([a-z]\:)',path,re.I) and not re.match(mapDriveRe,path,re.I):
							badpaths.append(path)
							
						# BLUR SPECIFIC HACK
						# If we are using a G: mirror, check if maps are in proper directories
						try:
							if usingGMirror:
								valid = False
								for re_ in validGPathRegs:
									if path.contains( re_ ):
										valid = True
										break
								if not valid:
									badpaths2.append(path)
						except:
							print "Exception while testing for valid g mirror paths"
							traceback.print_exc()
					except:
						print "Invalid Line Format in Stats File:", line
		
		if badpaths2:
			subject = 'Job contains bad maps, pc2 or xref paths'
			print subject, job.key(), job.name()
			body = "Job: %s\n" % job.name()
			body += "Job ID: %i\n" % job.key()
			body += "User: %s\n" % job.user().displayName()
			body += "This job contains maps, pointcache or xrefs that\n"
			body += "point to locations that can not be reached by render nodes. Please\n"
			body += "make sure your maps are stored with the project on %s.\n"
			body += "Jobs that use maps via UNC paths such as \\\\thor or \\\\snake,"
			body += "or through drive letters other than %s will NOT render on the farm.\n\n"
			body += "List of invalid paths:\n"
			body = body % (config.permissableMapDrives, config.permissableMapDrives)
			for path in badpaths:
				body += path + "\n"
				print path
			notifySend( notifyList = "newellm:j", subject = subject, body = body )
			
		if badpaths:
			subject = 'Job contains bad maps, pc2 or xref paths'
			print subject, job.key(), job.name()
			body = "Job: %s\n" % job.name()
			body += "Job ID: %i\n" % job.key()
			body += "User: %s\n" % job.user().displayName()
			body += "This job contains maps, pointcache or xrefs that\n"
			body += "point to locations that can not be reached by render nodes. Please\n"
			body += "make sure your maps are stored with the project on %s.\n"
			body += "Jobs that use maps via UNC paths such as \\\\thor or \\\\snake,"
			body += "or through drive letters other than %s will NOT render on the farm.\n\n"
			body += "List of invalid paths:\n"
			body = body % (config.permissableMapDrives, config.permissableMapDrives)
			for path in badpaths:
				body += path + "\n"
				print path
			
			job.setStatus('suspended')
			job.commit()
			notifylist = "it:e,%s:je" % (job.user().name())
			notifySend( notifyList = notifylist, subject = subject, body = body )
			return False
	
	if job.table().schema().field( 'frameStart' ) and job.table().schema().field( 'frameEnd' ):
		minMaxFrames = Database.current().exec_('SELECT min(jobtask), max(jobtask) from JobTask WHERE fkeyjob=%i' % job.key())
		if minMaxFrames.next():
			job.setValue( 'frameStart', minMaxFrames.value(0) )
			job.setValue( 'frameEnd', minMaxFrames.value(1) )

	print "checking job dependencies"
	status = 'ready'
	for jobDep in JobDep.recordsByJob( job ):
		if jobDep.depType() == 1 and jobDep.dep().status() != 'done' and jobDep.dep().status() != 'deleted':
			status = 'holding'
	if job.status() == 'verify-suspended':
		status = 'suspended'
	job.setStatus(status)
	print "creating job stat"
	createJobStat(job)
	job.commit()

	print "New Job %s is ready" % ( job.name() )
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
                                      AND jobtaskassignment.started IS NOT NULL 
                                      AND jobtaskassignment.ended IS NOT NULL""" % (job.key()))
	if q.next():
		return q.value(0).toInt()[0]
	return 0

def getAvgMemory(job):
	q = Database.current().exec_("SELECT AVG( jobtaskassignment.memory )::int FROM JobTaskAssignment INNER JOIN JobTask ON JobTask.fkeyjobtaskassignment=jobtaskassignment.keyjobtaskassignment WHERE jobtask.fkeyjob=%i AND jobtaskassignment.memory IS NOT NULL AND jobtaskassignment.memory > 0" % (job.key()))
	if q.next():
		return q.value(0).toInt()[0]
	return 0
	
def retrieveReapable():
	jobList = Job.select("status IN ('verify','verify-suspended','ready','started')")
	if not jobList.isEmpty():
		JobStatus.select("fkeyjob IN ("+jobList.keyString()+")")
	return jobList

def retrieveCleanable():
	return Job.select("status IN ('deleted') AND (cleaned IS NULL OR cleaned=0)")

service = Service.ensureServiceExists('AB_Reaper')

# Holds PID of checker:Job
newJobCheckers = {}

def reaper():
    #	Config: managerDriveLetter, managerSpoolDir, assburnerErrorStep
    print "Reaper is starting up"
    notifySend( notifyList = 'newellm:j', subject = 'Reaper Starting', body = "Reaper is (re)starting" )

    errorStep = Config.getInt('assburnerErrorStep')

    # Make sure that people get notified at most once per error
    if not errorStep or errorStep < 1:
        errorStep = 1
        
    while True:
        # Remove checker from dict if the process has exited, so
        # we can recheck the job if it failed
        try:
            for pid in newJobCheckers.keys():
                result = os.waitpid(pid,os.WNOHANG)
                if result and result[0] == pid:
                    del newJobCheckers[pid]
                    print 'Job Checker Child Process: %i Exited with code: %i' % result
        except:
            print "Exception During newJobCheckers waitpid checking."
            traceback.print_exc()

        service.pulse()
        config.update()
        if config.spoolDir != "":
            ensureSpoolSpace(config.requiredSpoolSpacePercent)

        for job in retrieveReapable():
            if VERBOSE_DEBUG: print "Checking Job %i %s" % (job.key(), job.name())
            status = str(job.status())

            if status.startswith('verify'):
                if config.assburnerForkJobVerify:
                    if VERBOSE_DEBUG: print "Forking verify thread for %s" % (job.name())
                    if not job in newJobCheckers.values():
                        pid = os.fork()
                        Database.current().connection().reconnect()
                        if pid == 0:
                            checkNewJob(job)
                            os._exit(0)
                        else:
                            newJobCheckers[pid] = job
                else:
                    checkNewJob(job)
                continue

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

            #timeoutCount = getTimeoutCount(job)

            avgTaskTime = getAvgTaskTime(job)
            js.setTasksAverageTime(avgTaskTime)

            js.setAverageMemory(getAvgMemory(job))

            # If job is erroring with no success, suspend it
            if done == 0 and errorCount > config.totalFailureThreshold:
                suspend = True
                suspendMsg = 'Job %s has been suspended.  The job has produced %i errors with no tasks completing.' % (job.name(),errorCount)
                suspendTitle = 'Job %s suspended.' % job.name()

            if suspend:
                # Return tasks and hosts
                Job.updateJobStatuses( JobList(job), 'suspended', False )
                notifyList = str(job.notifyOnError())
                # If they don't have notifications on for job errors, then
                # notify them via email and jabber
                if len(notifyList) == 0:
                    notifyList = job.user().name() + ':je'
                # Notify me for now.
                # notifyList += ',newellm:j'
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
                Database.current().exec_('SELECT update_job_deps(%i)' % job.key())

            job.commit()
            js.commit()

        cleanupJobs()

        if VERBOSE_DEBUG: print "Sleeping for 3 seconds"
        time.sleep(3)

def notifyOnCompleteSend(job):
	if VERBOSE_DEBUG:
		print 'notifyOnCompleteSend(): Job %s is complete.' % (job.name())
	msg = 'Job %s is complete.' % (job.name())
	notifySend( notifyList = job.notifyOnComplete(), subject = msg, body = msg )

def notifyOnErrorSend(job,errorCount):
	if VERBOSE_DEBUG:
		print 'notifyOnErrorSend(): Job %s has errors.' % (job.name())
	msg = 'Job %s has %i errors.' % (job.name(),errorCount)
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

def createJobStat( mJob ):
	stat = JobStat()
	stat.setName( mJob.name() )
	stat.setElement( mJob.element() )
	stat.setProject( mJob.project() )
	stat.setUser( mJob.user() )
	stat.commit()
	mJob.setJobStat( stat )
	mJob.commit()

reaper()
