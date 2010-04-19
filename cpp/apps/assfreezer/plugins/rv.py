
from blur.Stone import *
from blur.Classes import *
from blur.Assfreezer import *
from PyQt4.QtCore import *
from PyQt4.QtSql import *
import traceback, os

class RvViewerPlugin(JobViewerPlugin):
    def __init__(self):
        JobViewerPlugin.__init__(self)

    def name(self):
        return QString("rv")

    def icon(self):
        return QString("images/framecycler.png")

    def view(self, jobList):
        print "open with rv ftw!"

JobViewerFactory.registerPlugin( RvViewerPlugin() )

