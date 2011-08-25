
import sys
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
sippath = os.path.join(path,'sipClasses')

try:
	os.mkdir(sippath)
except: pass

pre_deps = ["stone"]
post_deps = []

# Here is the static command for running classmaker to generate the classes
classmakercmd = 'cd ../../apps/classmaker && ./classmaker'
if sys.platform == 'win32':
	classmakercmd = 'classmaker.exe'

# Run using cmd in path, unless we are inside the tree
if os.path.isfile(os.path.join(path,'../../apps/classmaker/',classmakercmd)):
	if sys.platform != 'win32':
		classmakercmd = './' + classmakercmd
	classmakercmd = 'cd ../../apps/classmaker && ' + classmakercmd

classgen = StaticTarget("classgen",path,classmakercmd + " -s " + path + "/schema.xml -o " + path,["classmaker"],shell=True)
pre_deps.append(classgen)

# Python module targets, both depend on classes
pc = SipTarget("pyclasses",path)
pc.pre_deps = [classgen,"classes","pystone:install"]
sst = SipTarget("pyclassesstatic",path,True)

sst.pre_deps = [classgen,"classes"]

# Install the libraries
if sys.platform != 'win32':
	LibInstallTarget("classesinstall",path,"classes","/usr/lib/")

QMakeTarget("classes",path,"classes.pro",pre_deps,post_deps)

if sys.platform=="linux2":
	rpm = RPMTarget('classesrpm','blur-classes',path,'../../../rpm/spec/classes.spec.template','1.0',["stonerpm", "classes","classesui","classmaker","pyclasses","pyclassesui"])
#	pyrpm = RPMTarget('pyclassesrpm','pyclasses',path,'../../../rpm/spec/pyclasses.spec.template','1.0')

if __name__ == "__main__":
	build()
