VPATH = C:\source\arsenalsuite\cpp\lib\PyQt4\designer
CONFIG      += designer plugin release warn
TARGET      = pythonplugin
TEMPLATE    = lib

INCLUDEPATH += c:\python24\include
LIBS        += -Lc:\python24\libs -lpython24
DEFINES     += PYTHON_LIB=\\\"python24.dll\\\"

SOURCES     = pluginloader.cpp
HEADERS     = pluginloader.h

# Install.
target.path = C:\Qt\4.6.1\plugins/designer

python.path = C:\Qt\4.6.1\plugins/designer
python.files = python

INSTALLS    += target python
