
import os
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')

# Python module target
pc = SipTarget("pyassfreezer",path)
pc.pre_deps = ["libassfreezer","pyclasses:install"]

pcs = SipTarget("pyassfreezerstatic",path,True)

QMakeTarget("libassfreezer",path,"libassfreezer.pro",["classesui","absubmit"])

if sys.platform=="linux2":
	rpm = RPMTarget('libassfreezerrpm','libassfreezer',path,'../../../rpm/spec/libassfreezer.spec.template','1.0')
	rpm.pre_deps = ["libabsubmitrpm"]


if __name__ == "__main__":
	build()
