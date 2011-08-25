
import sys,os,xmpp

class farmBot:
    def __init__(self, user, password, nick='Render Farm'):
        sender_jid = xmpp.protocol.JID(str(user))
        self.user = user
        self.nick = nick

        self.client = xmpp.Client(sender_jid.getDomain(),debug=[])
        self.client.connect(secure=0,use_srv=False)
        self.client.auth(sender_jid.getNode(),str(password),sender_jid.getResource())

        self.client.sendPresence(typ='available')
        self.rooms = []

        self.client.RegisterHandler('message', self.message)

    def process(self):
        self.client.Process()

    def joinRoom(self, room):
        self.client.sendPresence("%s/%s" % (room, self.nick))
        if not room in self.rooms:
            self.rooms.append(room)

    def leaveRoom(self, room):
        self.client.sendPresence("%s/%s" % (room, self.nick), typ='unavailable')
        if room in self.rooms:
            self.rooms.remove(room)

    def logOut(self):
        for room in self.rooms:
            self.client.sendPresence("%s/%s" % (room, self.nick), typ='unavailable')

        self.client.sendPresence(typ='unavailable')

    def send(self, receiver, text, sendType='chat'):
        receiver_jid = xmpp.protocol.JID(str(receiver))
        self.client.send(xmpp.protocol.Message(str(receiver),str(text),typ=sendType))

    # drop the message
    def message(self, conn, mess):
        pass

# Legacy compat below

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
