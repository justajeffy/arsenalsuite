
from blur.build import *
import os, sys

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')

ini = IniConfigTarget("assfreezerini",path,'assfreezer.ini.template','assfreezer.ini')
nsi = NSISTarget("assfreezer_installer",path,"assfreezer.nsi")

# Use Static python modules on windows
deps = None
if sys.platform == 'win32':
	deps = ["sipstatic","pystonestatic","pyclassesstatic","classes","libassfreezer","pyassfreezerstatic",ini]
else:
	deps = ["sipstatic","pystone","pyclasses","classes","libassfreezer","pyassfreezer",ini]

QMakeTarget("assfreezer",path,"assfreezer.pro",deps,[nsi])

if sys.platform=="linux2":
	rpm = RPMTarget('assfreezerrpm','assfreezer',path,'../../../rpm/spec/assfreezer.spec.template','1.0')

if __name__ == "__main__":
	build()
