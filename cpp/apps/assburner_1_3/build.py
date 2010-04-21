
from blur.build import *
import os, sys

path = os.path.dirname(os.path.abspath(__file__))
sip_path = os.path.join(path,'sipAssburner')
rev_path = os.path.join(path,'../..')

try:
    os.mkdir(sip_path)
except: pass

ini = IniConfigTarget("assburner_1_3ini",path,'assburner.ini.template','assburner.ini')
svn = WCRevTarget("assburner_1_3svnrev",path,rev_path,"include/svnrev-template.h","include/svnrev.h")
svnnsi = WCRevTarget("assburner_1_3svnrevnsi",path,rev_path,"assburner-svnrev-template.nsi","assburner-svnrev.nsi")
svntxt = WCRevTarget("assburner_1_3svnrevtxt",path,rev_path,"assburner_version_template.txt","assburner_version.txt")
nsi = NSISTarget("assburner_1_3installer",path,"assburner.nsi")
nsi.pre_deps = [svnnsi,svntxt]
st = SipTarget("pyassburner_1_3",path,True)
#abgui = QMakeTarget("abgui","apps/assburner", "abgui.pro", ["stonegui","classes",svn])

# Use Static python modules on windows
deps = None
if sys.platform == 'win32':
	deps = ["sipstatic","pystonestatic","pyclassesstatic","classes",st,svn,ini]
else:
	deps = ["sipstatic","pystone","pyclasses","classes",st,svn,ini]

assburner = QMakeTarget("assburner",path, "assburner.pro", deps)
abpsmon = QMakeTarget("abpsmon",os.path.join(path,'psmon'), "psmon.pro", ["stonegui","classes",svn,ini])
Target("assburner_1_3",path, [assburner,abpsmon],[nsi])

rpm = RPMTarget('assburnerrpm','assburner',path,'../../../rpm/spec/assburner.spec.template','1.0')
rpm.pre_deps = ['stoneguirpm','classesrpm','stonerpm']

if __name__ == "__main__":
	build()
