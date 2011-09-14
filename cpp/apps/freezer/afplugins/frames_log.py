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
        self.wantedTask = None
        self.jobTaskAssignments = None

    def name(self):
        return QString("Frames tab log viewer")

    # Called by freezer when it starts building the frames tab on startup
    def initialize(self, parent):
        # Add a new tab
        self.tabWidget = QWidget()
        parent.addTab(self.tabWidget, "Logs")

        # Initialise the layout for the log tab
        self.verticalLayout = QVBoxLayout(self.tabWidget)
        self.horizontalLayout = QHBoxLayout()
        
        # Add a checkbox to toggle showing previous runs
        self.showPreviousRuns = QCheckBox(self.tabWidget)
        self.showPreviousRuns.setChecked(False)

        # Add it's label as well
        self.showPreviousRunsLabel = QLabel(self.tabWidget)
        self.showPreviousRunsLabel.setText(QApplication.translate("ShowPreviousRunLogs", "Show previous run logs", None, QApplication.UnicodeUTF8))

        # Finally add the spacer
        self.showPreviousRunsSpacer = QSpacerItem(40, 20, QSizePolicy.Expanding, QSizePolicy.Minimum)

        # Add the QComboBox for the previous runs
        self.previousRunsDropDown = QComboBox(self.tabWidget)
        self.previousRunsDropDown.hide()

        # Initialise the log viewer
        self.logviewer = QTextEdit(self.tabWidget)
        self.logviewer.setReadOnly(True)

        # Add the text editor to the layout and show the table.
        self.horizontalLayout.addWidget(self.showPreviousRuns)
        self.horizontalLayout.addWidget(self.showPreviousRunsLabel)
        self.horizontalLayout.addItem(self.showPreviousRunsSpacer)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.verticalLayout.addWidget(self.previousRunsDropDown)
        self.verticalLayout.addWidget(self.logviewer)

        # Connect the combo box to the check box
        QObject.connect(self.showPreviousRuns, SIGNAL('stateChanged(int)'), self.toggleComboBox)

    # Slot to show and hide the combo box
    def toggleComboBox(self, state):
        if state == 2:
            self.previousRunsDropDown.show()

            # Connect the combo box to change the log view
            QObject.connect(self.previousRunsDropDown, SIGNAL('currentIndexChanged(int)'), self.setLogView)

            # Get the previous tasks
            self.getPreviousTaskRun(self.wantedTask)
        else:
            self.previousRunsDropDown.hide()

            # Disconnect the combo box
            QObject.disconnect(self.previousRunsDropDown, SIGNAL('currentIndexChanged(int)'), self.setLogView)


    # Called by freezer when you click on a job
    def setJobList(self, jobList):
        pass

    # Called by freezer when you click on a job task
    def setJobTaskList(self, jobTasks):
        # If we haven't selected anything, then let's not do anything
        if jobTasks.size() == 0:
            return

        # reset the job task assignments
        self.jobTaskAssignments = None

        # clear the checkbox for showing extra logs
        self.showPreviousRuns.setChecked(False)

        # This is a log viewer so we only take the first task
        wantedTask = jobTasks[0]
        if wantedTask.isRecord():
            # Store the record
            self.wantedTask = wantedTask

            self.setLogView(None)

    def setLogView(self, index):
        # We clear the log viewer only if a valid task has been selected
        self.logviewer.clear()

        # Grab the assignment from the task
        assignment = None
        if index != None and self.jobTaskAssignments != None:
            assignment = self.jobTaskAssignments[index].jobAssignment()
        else:
            assignment = self.wantedTask.jobTaskAssignment().jobAssignment()

        # Get the log file name
        log = assignment.stdOut()

        # Grab the text cursor
        textCursor = self.logviewer.textCursor()

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

        # Move the cursor position to the end of the log so that we view the bottom first
        textCursor.movePosition(QTextCursor.End)
        self.logviewer.setTextCursor(textCursor)

    # Gather the previous logs for the task
    def getPreviousTaskRun(self, jobTask):
        # This is true only when the combo box is not shown
        if jobTask == None:
            return

        # We clear the combo box otherwise it'll just append
        self.previousRunsDropDown.clear()

        # Grab the job assignments related to the task
        self.jobTaskAssignments = JobTaskAssignment.select("fkeyjobtask=? order by ended desc", [QVariant(jobTask.key())])
        for jta in self.jobTaskAssignments:
            assignment = jta.jobAssignment()
            if assignment.isRecord():
                if assignment.ended().toString() == "":
                    self.previousRunsDropDown.addItem("Currently running..")
                else:
                    self.previousRunsDropDown.addItem(assignment.ended().toString("dd/MM/yy - hh:mm:ss"))

# Don't forget to register the widget with the factory or it won't show up in freezer
JobFramesTabWidgetFactory.registerPlugin( FrameLogViewerPlugin() )
