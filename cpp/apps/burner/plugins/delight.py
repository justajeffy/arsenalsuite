
from blur.Stone import *
from blur.Classes import *
from blur.Burner import *
from PyQt4.QtCore import *
from PyQt4.QtSql import *
import traceback, os

class DelightBurner(JobBurner):
    def __init__(self,jobAss,slave):
        JobBurner.__init__(self,jobAss,slave)
        self.Job = jobAss.job()
        self.CurrentFrame = None
        self.frameList = []
        self.StartFrame = None
        self.EndFrame = None

        # Rendering /drd/jobs/hf2/global/rnd/surfdev/artur.vill/empland/houdini/ribs/empland.1191.rib
        if self.burnFile().endsWith("..rib"):
            self.frameStart = QRegExp("^# Rendering.*\.(\d+)\.rib")
        else:
            self.frameStart = QRegExp("^# Rendering.*\.rib")

        # Statistics for frame 1049
        self.frameDone = QRegExp("Statistics for frame (\d+)")

        self.jobDone = QRegExp("^baztime:")

    def __del__(self):
        # Nothing is required
        # self.cleanup() is explicitly called by the slave
        pass

    def cleanup(self):
        Log( "DelightBurner::cleanup() called" )
        if not self.process():
            Log( "DelightBurner::cleanup() process doesn't even exist" )
            return
        mProcessId = self.process().pid()
        Log( "DelightBurner::cleanup() Getting pid: %s" % mProcessId )

        # Need to find the correct PID space ..
        if mProcessId > 10:
            descendants = processChildrenIds( mProcessId, True )
            for processId in descendants:
                Log( "DelightBurner::cleanup() Killing child pid: %s" % processId )
                killProcess( processId )
            killProcess( mProcessId )

        JobBurner.cleanup(self)
        Log( "DelightBurner::cleanup() done" )

    # Names of processes to kill after burn is finished
    def processNames(self):
        return QStringList()

    def environment(self):
        env = self.Job.environment()
        Log( "DelightBurner::environment(): %s" % env )
        return env.split("\n")

    def buildCmdArgs(self):
        return QStringList()

    def executable(self):
        self.frameList = expandNumberList( self.assignedTasks() )[0]
        if not len( self.frameList ) > 0:
            Log( "DelightBurner::executable(): assigned %s" % self.assignedTasks() )
            self.jobErrored("got no assigned tasks =(")
            return ""
        self.StartFrame = self.frameList[0]
        self.EndFrame = self.frameList[-1]

        timeCmd = "/usr/bin/time --format=baztime:real:%e:user:%U:sys:%S:iowait:%w ";
        renderdl = os.getenv("RENDERDL","renderdl")
        cmd = timeCmd + "/bin/su %s -c \"%s " % (self.Job.user().name(), renderdl)

        args = QStringList()
        args << "-nd"
        args << "-Progress"
        args << "-t"
        args << str(self.Job.threads())
        args << "-stats2"
        args << "-init"

        if self.burnFile().endsWith("..rib"):
            for n in self.frameList:
                rib = self.burnFile().replace("..rib", (".%04d.rib" % n))
                if( self.Job.outputPath().isEmpty() ):
                    self.guessOutputPath(rib)
                args << rib
        else:
            args << "-frames"
            args << str(self.StartFrame) << str(self.EndFrame)
            args << self.burnFile()
            if( self.Job.outputPath().isEmpty() ):
                self.guessOutputPath(self.burnFile())

        cmd = cmd + args.join(" ") + "\""

        return cmd

    def guessOutputPath(self, rib):
        Log( "DelightBurner: no outputPath available, trying to deduce from: "+ rib )
        ribFile = open(rib)
        for line in ribFile:
            if( 'Display' in line and 'rgba' in line):
                # Display "/farm/drd/jobs/hf2/pic/depts/surface/artur.vill/human/05_camH02f/human_dir.0884.tif" "null" "rgba"
                outRE = QRegExp("Display \"([^\"]+)\"")
                if( outRE.indexIn(line) ):
                    outputPath = outRE.cap(1)
                    Log( "DelightBurner: set outputPath: "+ outputPath )
                    self.Job.setOutputPath(outputPath)
                    self.Job.commit()
        ribFile.close()

    def startProcess(self):
        Log( "DelightBurner::startBurn() called" )
        JobBurner.startProcess(self)
        Log( "DelightBurner::startBurn() done" )

    def slotProcessOutputLine(self,line,channel):
        JobBurner.slotProcessOutputLine(self,line,channel)

        # Frame status
        if self.frameStart.indexIn(line) >= 0:
            if self.CurrentFrame is None:
                self.CurrentFrame = self.StartFrame
            else:
                self.taskDone(self.CurrentFrame)
                self.CurrentFrame = self.CurrentFrame + 1

            if self.CurrentFrame <= self.EndFrame:
                self.taskStart(self.CurrentFrame)
        elif line.contains(self.jobDone):
            self.taskDone(self.CurrentFrame)
            self.jobFinished()

class DelightBurnerPlugin(JobBurnerPlugin):
    def __init__(self):
        JobBurnerPlugin.__init__(self)

    def jobTypes(self):
        return QStringList('3Delight')

    def createBurner(self,jobAss,slave):
        Log( "DelightBurnerPlugin::createBurner() called, Creating DelightBurner" )
        if jobAss.job().jobType().name() == '3Delight':
            return DelightBurner(jobAss,slave)

JobBurnerFactory.registerPlugin( DelightBurnerPlugin() )

