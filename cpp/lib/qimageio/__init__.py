
import os

import exr
#import hdr
import rla
import sgi
import tga

from blur.build import *

All_Targets.append( Target('qimageioplugins',os.path.abspath(os.getcwd()),[
		"exrplugin","rlaplugin","sgiplugin","tgaplugin"]) )
