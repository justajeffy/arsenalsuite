
import os
import sipconfig
import PyQt4.pyqtconfig as pyqtconfig
import sys

# The name of the SIP build file generated by SIP and used by the build
# system.
build_file = "assburner.sbf"

# Get the PyQt configuration information.
config = pyqtconfig.Configuration()
config.pyqt_modules = []

# Get the extra SIP flags needed by the imported qt module.  Note that
# this normally only includes those flags (-x and -t) that relate to SIP's
# versioning system.
qt_sip_flags = config.pyqt_sip_flags

# Run SIP to generate the code.  Note that we tell SIP where to find the qt
# module's specification files using the -I flag.
#config.pyqt_sip_dir = "/usr/share/sip/PyQt4"
#config.pyqt_sip_dir = "c:\\python24\\sip\\PyQt4\\"

config.__dict__["AR"] = "ar r"
if sys.platform=="win32":
	sip_bin = "..\\..\\lib\\sip\\sipgen\\sip.exe"
else:
	sip_bin = config.sip_bin
sipgencmd = " ".join([sip_bin, "-c", "sipAssburner", "-b", "sipAssburner/" + build_file, "-I", config.pyqt_sip_dir, "-I", config.default_sip_dir, qt_sip_flags, "sip/assburner.sip"])
#print sipgencmd
ret = os.system(sipgencmd)
if ret:
	
	sys.exit(ret%255)

# We are going to install the SIP specification file for this module and
# its configuration module.
#installs = []
#installs.append(["sip/assburner.sip", os.path.join(config.default_sip_dir, "Blur")])
#installs.append(["assburnerconfig.py", config.default_mod_dir])

class AssburnerModuleMakefile(pyqtconfig.QtCoreModuleMakefile):
    def __init__(self, *args, **kw):
        if not kw.has_key("qt"):
            kw["qt"] = ["QtCore", "QtXml", "QtSql","QtNetwork","QtGui"]
        apply(pyqtconfig.QtCoreModuleMakefile.__init__, (self, ) + args, kw)

# Create the Makefile.  The QtModuleMakefile class provided by the
# pyqtconfig module takes care of all the extra preprocessor, compiler and
# linker flags needed by the Qt library.
makefile = AssburnerModuleMakefile(
	configuration=config,
	build_file=build_file,
#	installs=installs,
	static=1,
	debug=sys.argv.count("-u"),
	dir="sipAssburner"
)

sipconfig.ParentMakefile(
	configuration=config,
	subdirs=["sipAssburner"]
).generate()

# Add the library we are wrapping.  The name doesn't include any platform
# specific prefixes or extensions (e.g. the "lib" prefix on UNIX, or the
# ".dll" extension on Windows).
makefile.extra_libs = ["classes","stone","Mpr"]

makefile.extra_include_dirs = ["../../../lib/classes/autocore","../../../lib/classes","../../../lib/stone/include","../include","../../../lib/libtorrent/include",
"/usr/include/classes","/usr/include/stone/"]

if sys.platform == "win32":
	makefile.extra_include_dirs.append("c:/Boost/include/boost-1_32")
else:
	makefile.extra_include_dirs.append("/mnt/storage/boost")

makefile.extra_lib_dirs.append( "../../../lib/classes" );
makefile.extra_lib_dirs.append( "../../../lib/stone" );

# Generate the Makefile itself.
makefile.generate()

# Now we create the configuration module.  This is done by merging a Python
# dictionary (whose values are normally determined dynamically) with a
# (static) template.
content = {
	# Publish where the SIP specifications for this module will be
	# installed.
	"assburner_sip_dir":    config.default_sip_dir,

	# Publish the set of SIP flags needed by this module.  As these are the
	# same flags needed by the qt module we could leave it out, but this
	# allows us to change the flags at a later date without breaking
	# scripts that import the configuration module.
	"assburner_sip_flags":  qt_sip_flags
}

# This creates the helloconfig.py module from the helloconfig.py.in
# template and the dictionary.
#sipconfig.create_config_module("assburnerconfig.py", "assburnerconfig.py.in", content)
