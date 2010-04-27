
from blur.build import *
from distutils import sysconfig

path = os.path.dirname(os.path.abspath(__file__))

makensis_extra_options = ['/DPYTHON_PATH=%s' % sysconfig.get_config_vars()['prefix'] ]
makensis_extra_options.append( '/DPYTHON_VERSION_MINOR=%s' % sysconfig.get_python_version().split('.')[1] )
makensis_extra_options.append( '/DPYTHON_VERSION_MAJOR=%s' % sysconfig.get_python_version().split('.')[0] )
makensis_extra_options.append( '/DPYTHON_VERSION=%s' % sysconfig.get_python_version() )
nsis = NSISTarget( "pyqt_installer", path, "PyQt4.nsi", makensis_extra_options = makensis_extra_options, pre_deps = ["pyqt","pyqtwinmigrate","qscintilla_python"] )

class PyQtTarget(SipTarget):
	def configure_command(self):
		config = SipTarget.configure_command(self)
		if self.has_arg("-verbose"):
			config += " -w"
		return config
		

pyqt = PyQtTarget("pyqt",path,False,None,["sip"] )

rpm = RPMTarget("pyqtrpm","pyqt",path,"../../../rpm/spec/pyqt.spec.template","1.0")
rpm.pre_deps = ["siprpm"]

pyqt.post_deps = [nsis]

if __name__ == "__main__":
	build()

