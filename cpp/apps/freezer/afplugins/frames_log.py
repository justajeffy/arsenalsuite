# All the arsenal libs that we use
from blur.Stone import *
from blur.Classes import *
from blur.Freezer import *

# PyQt libs for GUI manipulation
from PyQt4.QtCore import *
from PyQt4.QtSql import *
from PyQt4.QtGui import *

class FrameLogViewerPlugin(JobFramesTabWidgetPlugin):
    def __init__(self):
        JobFramesTabWidgetPlugin.__init__(self)

    def name(self):
        return QString("Frames tab log viewer")

    # Called by freezer when it starts building the frames tab on startup
    def initialize(self, parent):
        # Add a new tab
        self.tabWidget = QWidget()
        parent.addTab(self.tabWidget, "Logs")

        # Initialise the layout for the log tab and the log viewer itself
        self.verticalLayout = QVBoxLayout(self.tabWidget)
        self.logviewer = QTextEdit(self.tabWidget)
        self.logviewer.setReadOnly(True)

        # Add the text editor to the layout and show the table.
        self.verticalLayout.addWidget(self.logviewer)

    # Called by freezer when you click on a job
    def setJobList(self, jobList):
        pass

    # Called by freezer when you click on a job task
    def setJobTaskList(self, jobTasks):
        # If we haven't selected anything, then let's not do anything
        if jobTasks.size() == 0:
            return

        # This is a log viewer so we only take the first task
        wantedTask = jobTasks[0]
        if wantedTask.isRecord():
            # We clear the log viewer only if a valid task has been selected
            self.logviewer.clear()

            # Grab the assignment from the task
            assignment = wantedTask.jobTaskAssignment().jobAssignment()

            # Get the log file name
            log = assignment.stdOut()

            # Ensures that if you choose a new frame that hasn't run before we don't try opening anything
            if log != '':
                finalLogs = []
                file = open(log, 'r')
                line = file.readline()

                while line != '':
                    finalLogs.append(line)
                    line = file.readline()

                # Set the text
                self.logviewer.setText("".join(finalLogs))

        # Set the initial scroll location to the bottom of the text
        scrollbar = self.logviewer.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())


# Don't forget to register the widget with the factory or it won't show up in freezer
JobFramesTabWidgetFactory.registerPlugin( FrameLogViewerPlugin() )
