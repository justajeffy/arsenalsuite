VPATH = C:\Users\aren.villanueva\Desktop\arsenalsuite\cpp\lib\PyQt4\designer
CONFIG      += designer plugin release warn
TARGET      = pythonplugin
TEMPLATE    = lib

INCLUDEPATH += C:\Python27\include
LIBS        += -LC:\Python27\libs -lpython27
DEFINES     += PYTHON_LIB=\\\"python27.dll\\\"

SOURCES     = pluginloader.cpp
HEADERS     = pluginloader.h

# Install.
target.path = C:\Qt\4.7.4\plugins/designer

python.path = C:\Qt\4.7.4\plugins/designer
python.files = python

INSTALLS    += target python
