# This script lives in
# ab working version /drd/software/ext/ab/lin64/201006291443/afplugins/
# local copy ~/arsenalsuite/cpp/apps/assfreezer/afplugins/ 

from blur.Stone import *
from blur.Classes import *
from blur.Assfreezer import *
from PyQt4.QtCore import *
from PyQt4.QtSql import *
import traceback, os
import subprocess

sys.path.append('/drd/software/ext/python/lin64/2.5/shotgun/v3')
from shotgun_api3 import Shotgun


SERVER_PATH = 'http://shotgun-eval' # change this to https if your studio uses SSL
SCRIPT_USER = 'arsenal-plugin'
SCRIPT_KEY = '92fe47ba36fa6d81b5492f51da1e43c23cdb705f'

SHOTGUN_SUBMITTER = "/drd/depts/it/dm/shotgunPlugin/shotgunsubmitter.py"

class ShotgunPlugin(JobViewerPlugin):
    def __init__(self):
        JobViewerPlugin.__init__(self)

    def name(self):
        return QString("Support Ticket")

    def icon(self):
        return QString("images/shotgun.png")

    def view(self, jobList):
	output = subprocess.Popen(SHOTGUN_SUBMITTER, stderr=subprocess.PIPE, stdout=subprocess.PIPE).communicate()
	submitShotgunTicket(str(output[0]), jobList)
	

def submitShotgunTicket(output, jobList):

	currentuser = str(User.currentUser().name())
	title = "Arsenal Support Request - Initiated by %s"%currentuser

	desc = []
	desc.append(output+"\n")
	desc.append("JOBLIST:") 

	for job in jobList:
	    desc.append(str(job.key())+" - "+str(job.name())) 
			
	#print title
	#print "\n".join(desc) 
	#sys.exit()

	sg = Shotgun(SERVER_PATH, SCRIPT_USER, SCRIPT_KEY)
	
        id = sg.find("HumanUser",[['login','is',currentuser]],['id'])
        userid = id[0]

        ticket_data = {
            'created_by': {'type':'HumanUser','id':userid['id']},
            'title': title,
            'description': "\n".join(desc),
            'addressings_to':[{'type':'Group', 'id':19}],
            'project': {'type':'Project', 'id':178},
            'sg_service': {'type':'CustomNonProjectEntity01', 'id':27},
        }
        sg_ticket = sg.create('Ticket', ticket_data, ['id'])
        new_ticket_url = SERVER_PATH + "/detail/Ticket/" + str(sg_ticket['id'])
        QDesktopServices.openUrl( QUrl(new_ticket_url) )

JobViewerFactory.registerPlugin( ShotgunPlugin() )

