
from PyQt4.QtCore import *
from PyQt4.QtSql import *
from blur.Stone import *
from blur.Classes import *

from verifier_plugin_factory import *

def doThis(job):
    print "checkOnTens - checking %s" % job.name()

    if( job.jobType().name() == "3Delight" ):
        prevFrame = False
        numbers = job.jobTasks().frameNumbers()
        numbers.sort()
        for frameNumber in numbers:
            if prevFrame and frameNumber - prevFrame > 9:
                print "checkOnTens - tens detected!"
                job.setPriority(29)
                job.setPacketType('continuous')
                job.commit()
                return True
            elif prevFrame:
                # only compare the first two frames..
                return True
            else:
                #print "checkOnTens - first frame is %i" % frameNumber
                prevFrame = frameNumber

    return True

VerifierPluginFactory().registerPlugin("checkOnTens", doThis)

