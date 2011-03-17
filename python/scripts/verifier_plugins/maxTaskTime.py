
from PyQt4.QtCore import *
from PyQt4.QtSql import *
from blur.Stone import *
from blur.Classes import *

from verifier_plugin_factory import *

def doThis(job):
    # if it has been changed from the submitter default
    # then don't modify it
    if( job.maxTaskTime() < 18000 ):
        return True

    if( job.jobType().name().contains( "Mantra" ) ):
        job.setMaxTaskTime(2 * 60 * 60)
        job.setThreads(4)
        job.setAssignmentSlots(4)
        job.setMaxMemory(8000000)
    if( job.jobType().name().contains( "3Delight" ) ):
        job.setMaxTaskTime(4 * 60 * 60)
        job.setThreads(4)
        job.setAssignmentSlots(4)
        job.setMaxMemory(8000000)
    if( job.jobType().name().contains( "Nuke" ) ):
        job.setMaxTaskTime(1800)

    job.commit()
    return True

VerifierPluginFactory().registerPlugin("maxTaskTime", doThis)

