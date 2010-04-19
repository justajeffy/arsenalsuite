
import os
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')

svn = WCRevTarget("libassfreezersvnrev",path,rev_path,"include/svnrev-template.h","include/svnrev.h")

# Python module target
pc = SipTarget("pyassfreezer",path)
pc.pre_deps = ["libassfreezer","pyclasses:install"]

pcs = SipTarget("pyassfreezerstatic",path,True)
pcs.pre_deps = ["pyclassesstatic:install"]

if sys.platform == 'win32':
	deps = ["sipstatic","pystonestatic","pyclassesstatic","pyclassesui","classesui","pyassfreezerstatic",svn]
else:
	deps = ["sipstatic","pyclassesui","classesui","pyassfreezerstatic",svn]

QMakeTarget("libassfreezer",path,"libassfreezer.pro",deps)
#QMakeTarget("libassfreezerstatic",path,"libassfreezer.pro",["stonestatic","stoneguistatic","classesuistatic","libabsubmit"],[],True)

rpm = RPMTarget('libassfreezerrpm','libassfreezer',path,'../../../rpm/spec/libassfreezer.spec.template','1.0')
rpm.pre_deps = ["libabsubmitrpm"]


if __name__ == "__main__":
	build()
