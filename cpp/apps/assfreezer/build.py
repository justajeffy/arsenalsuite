
from blur.build import *
import os

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')

ini = IniConfigTarget("assfreezerini",path,'assfreezer.ini.template','assfreezer.ini')
svn = WCRevTarget("assfreezersvnrev",path,rev_path,"src/svnrev-template.h","src/svnrev.h")
svnnsi = WCRevTarget("assfreezersvnrevnsi",path,rev_path,"assfreezer-svnrev-template.nsi","assfreezer-svnrev.nsi")
svntxt = WCRevTarget("assfreezersvnrevtxt",path,rev_path,"assfreezer_version_template.txt","assfreezer_version.txt");
nsi = NSISTarget("assfreezer_installer",path,"assfreezer.nsi")

# Use Static python modules on windows
deps = None
if sys.platform == 'win32':
	deps = ["sipstatic","pystonestatic","pyclassesstatic","classes","libassfreezer","pyassfreezerstatic",svnnsi,svntxt,svn,ini]
else:
	deps = ["sipstatic","pystone","pyclasses","classes","libassfreezer","pyassfreezerstatic",svnnsi,svntxt,svn,ini]

QMakeTarget("assfreezer",path,"assfreezer.pro",deps,[nsi])

rpm = RPMTarget('assfreezerrpm','assfreezer',path,'../../../rpm/spec/assfreezer.spec.template','1.0')

if __name__ == "__main__":
	build()
