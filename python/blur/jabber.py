
import sys,os,xmpp

# Logs into the sender jid's jabber server and authenticates
# with password.
# Sends a message to receiver with text as the contents
# The message is type='chat' unless sendAsChat=False
def send( sender, password, receiver, text, sendAsChat=True ):
	sender_jid = xmpp.protocol.JID(str(sender))
	receiver_jid = xmpp.protocol.JID(str(receiver))
	
	client = xmpp.Client(sender_jid.getDomain(),debug=[])
	client.connect(secure=0,use_srv=False)
	client.auth(sender_jid.getNode(),str(password),sender_jid.getResource())
	
	sendType = None # Regular Message
	if sendAsChat:
		sendType = 'chat'
	client.send(xmpp.protocol.Message(str(receiver),str(text),typ=sendType))
