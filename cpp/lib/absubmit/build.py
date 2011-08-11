
import os
import sys
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
QMakeTarget("libabsubmit",path,"libabsubmit.pro", ["stone","classes"],[])

if sys.platform=="linux2":
	rpm = RPMTarget('libabsubmitrpm','libabsubmit',path,'../../../rpm/spec/libabsubmit.spec.template','1.0')
	rpm.pre_deps = ['classesrpm','stonerpm']

	pyrpm = RPMTarget('pyabsubmitrpm','pyabsubmit',path,'../../../rpm/spec/pyabsubmit.spec.template','1.0')
	pyrpm.pre_deps = ['pystonerpm','pyclassesrpm','libabsubmitrpm']

# Python module target
pc = SipTarget("pyabsubmit",path)
pc.pre_deps = ["libabsubmit","pyclasses:install"]

if __name__ == "__main__":
	build()
