
import os
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
rev_path = os.path.join(path,'../..')



# Python module target
pc = SipTarget("pyfreezer",path)
pc.pre_deps = ["libfreezer","pyclasses:install"]

pcs = SipTarget("pyfreezerstatic",path,True)

QMakeTarget("libfreezer",path,"libfreezer.pro",["classesui","libabsubmit"])

if sys.platform=="linux2":
	rpm = RPMTarget('freezerrpm','freezer',path,'../../../rpm/spec/freezer.spec.template','1.0',["classesrpm","libfreezer","freezer","pyfreezer"])
#	rpm.pre_deps = ["libabsubmitrpm"]


if __name__ == "__main__":
	build()
