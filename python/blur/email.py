
#import email.MIMEText
import smtplib
# Have to load these like this, because this module is
# called email
MIMEText = __import__('email.MIMEText').MIMEText.MIMEText
MIMEMultipart = __import__('email.MIMEMultipart').MIMEMultipart.MIMEMultipart
MIMEBase = __import__('email.MIMEBase').MIMEBase.MIMEBase
Encoders = __import__('email.Encoders').Encoders
import sys
from blur.Stone import *
from blur.Classes import *
from PyQt4.QtCore import *
import quopri

# We have to initialize qt and stone before accessing the db
def ensure_qapp():
	if not QCoreApplication.instance():
		# First Create a Qt Application
		app = QCoreApplication(sys.argv)
		# Load database config
		if sys.platform=='win32':
			initConfig("c:\\blur\\resin\\resin.ini")
		else:
			initConfig("/etc/db.ini")

def send( sender, recipients, subject, body, attachments=[] ):
	#Ensure python strings
	recipients = [str(r) for r in recipients]
	subject = str(subject)
	body = str(body)
	sender = str(sender)
	
	if not sender:
		return
	
	# Read from config file first
	cfg = config()
	cfg.pushSection("Email")
	domain = cfg.readString("Domain")
	server = cfg.readString("Server")
	cfg.popSection()
	
	# Check database if not found in config and we have a connection
	if len(domain) == 0 and Database.current().connection().isConnected():
		domain = Config.getString("emailDomain")
	if len(server) == 0 and Database.current().connection().isConnected():
		server = Config.getString("emailServer")
		
	for (i,v) in enumerate(recipients):
		if not v.count('@'):
			ensure_qapp()
			emp = Employee.recordByUserName( v )
			if emp.isRecord() and not emp.email().isEmpty():
				recipients[i] = emp.email()
			if not v.count('@'):
				recipients[i] = v + str(domain)
	
	email = MIMEMultipart()
	email['Subject'] = subject
	email['From'] = sender
	email['To'] = ', '.join(recipients)
	email['Date'] = str(QDateTime.currentDateTime().toString('ddd, d MMM yyyy hh:mm:ss'))
	email['Content-type']="Multipart/mixed"
	email.preamble = 'This is a multi-part message in MIME format.'
	email.epilogue = ''
	
	#msgAlternative = MIMEMultipart('alternative')
	#email.attach(msgAlternative)
	
	msgText = MIMEText(body)
	msgText['Content-type'] = "text/plain"
	
	#msgAlternative.attach(msgText)
	email.attach(msgText)
	
	for a in attachments:
		fp = open( str(a), 'rb' )
		txt = MIMEBase("application", "octet-stream")
		txt.set_payload(fp.read())
		fp.close()
		Encoders.encode_base64(txt)
		txt.add_header('Content-Disposition', 'attachment; filename="%s"' % a)
		email.attach(txt)
		
	s = smtplib.SMTP()
	mailServer = str(server)
	s.connect(mailServer)
	print email.get_content_maintype()
	print "Sending email to ", recipients
	s.sendmail(sender, recipients, email.as_string())
	s.close()
	return True
