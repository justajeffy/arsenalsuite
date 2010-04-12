
import sys
from blur.build import *

path = os.path.dirname(os.path.abspath(__file__))
sippath = os.path.join(path,'sipStone')

try:
    os.mkdir(sippath)
except: pass

# Install the libraries
if sys.platform != 'win32':
	LibInstallTarget("stoneinstall",path,"stone","/usr/lib/")

# Python module targets
SipTarget("pystone",path,False,None,["sip:install","pyqt:install","stone"])
sst = SipTarget("pystonestatic",path,True)

#if sys.platform=='win32':
	#lib = 'pyStone.lib'
	#srclib = 'Stone.lib'
	#if sys.argv.count("debug"):
		#lib = 'pyStone_d.lib'
		#srclib = 'Stone_d.lib'
	#sst.post_deps = [CopyTarget("pystonecopy",sippath,srclib,lib)]
#else:
	#sst.post_deps = [CopyTarget("pystonecopy",sippath,"libStone.a","libpyStone.a")]

# Create the main qmake target
QMakeTarget("stone",path,"stone.pro")

# Create versioned dll and lib file
svnpri = WCRevTarget("stonelibsvnrevpri",path,"../..","svnrev-template.pri","svnrev.pri")
#post_deps.append(LibVersionTarget("stonelibversion","lib/stone","../..","stone"))

#sv = QMakeTarget("stoneversioned",path,"stone.pro",[],[svnpri])
#sv.Defines = ["versioned"]

rpm = RPMTarget('stonerpm','libstone',path,'../../../rpm/spec/stone.spec.template','1.0')
rpm.pre_deps = ["pyqtrpm"]

pyrpm = RPMTarget('pystonerpm','pystone',path,'../../../rpm/spec/pystone.spec.template','1.0')

if __name__ == "__main__":
	build()
