CONFIG      += designer plugin release warn
TARGET      = pythonplugin
TEMPLATE    = lib

INCLUDEPATH += /usr/include/python2.5
LIBS        += -L/usr/lib -lpython2.5
DEFINES     += PYTHON_LIB=\\\"libpython2.5.so\\\"

SOURCES     = pluginloader.cpp
HEADERS     = pluginloader.h

# Install.
target.path = /usr/local/Trolltech/Qt-4.5.3/plugins/designer

python.path = /usr/local/Trolltech/Qt-4.5.3/plugins/designer
python.files = python

INSTALLS    += target python
