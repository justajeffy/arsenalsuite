
import os
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')

ini = IniConfigTarget("absubmitini",path,'absubmit.ini.template','absubmit.ini')

#svn = WCRevTarget("resinaxsvnrev","apps/activex","../..","svnrev-template.h","svnrev.h")
svnnsi = WCRevTarget("absubmitsvnrevnsi",path,rev_path,"absubmit-svnrev-template.nsi","absubmit-svnrev.nsi")
svntxt = WCRevTarget("absubmitsvnrevtxt",path,rev_path,"absubmit_version_template.txt","absubmit_version.txt")
nsi = NSISTarget("absubmit_installer",path,"absubmit.nsi")
All_Targets.append(QMakeTarget("absubmit",path,"absubmit.pro",
    ["stone","classes","libabsubmit",svnnsi,svntxt,ini],[nsi]))

rpm = RPMTarget('absubmitrpm','absubmit',path,'../../../rpm/spec/absubmit.spec.template','1.0')
rpm.pre_deps = ['libabsubmitrpm']

if __name__ == "__main__":
	build()
