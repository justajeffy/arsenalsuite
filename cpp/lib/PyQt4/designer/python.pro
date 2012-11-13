VPATH = e:\source\arsenalsuite\cpp\lib\PyQt4\designer
CONFIG      += designer plugin release warn
TARGET      = pythonplugin
TEMPLATE    = lib

INCLUDEPATH += c:\python27_64\include
LIBS        += -Lc:\python27_64\libs -lpython27
DEFINES     += PYTHON_LIB=\\\"python27.dll\\\"

SOURCES     = pluginloader.cpp
HEADERS     = pluginloader.h

# Install.
target.path = E:\Qt\4.8.3_64\plugins/designer

python.path = E:\Qt\4.8.3_64\plugins/designer
python.files = python

INSTALLS    += target python
