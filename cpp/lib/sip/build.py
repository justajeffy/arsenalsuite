
import sys, os
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))

plat = 'win32-g++'
if 'QMAKESPEC' in os.environ:
	plat = os.environ['QMAKESPEC']
elif sys.platform != 'win32':
	if os.system('uname -p | grep x86_64') == 0:
		plat = 'linux-g++-64'
	else:
		plat = 'linux-g++'

class SipSipTarget(SipTarget):
    def configure_command(self):
        if "DESTDIR" in os.environ:
            python_version = "python" + sys.version[:3]
            self.config += " -b %s/bin" % os.environ['DESTDIR']
            self.config += " -d %s/lib/%s/site-packages" % (os.environ['DESTDIR'], python_version)
            self.config += " -e %s/include/%s" % (os.environ['DESTDIR'], python_version)
            self.config += " -v %s/share/sip" % os.environ['DESTDIR']

#SipTarget("sip",path,False,plat)
SipSipTarget("sip", path, False, plat)
#SipTarget("sipstatic",path,True,plat)
SipSipTarget("sipstatic", path, True, plat)
RPMTarget('siprpm','sip',path,'../../../rpm/spec/sip.spec.template','1.0')

if __name__=="__main__":
	build()
