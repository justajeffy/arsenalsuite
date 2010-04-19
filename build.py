#!/usr/bin/python

import os,sys
sys.path.insert(0,os.path.join(os.getcwd(),"python/"))
path = os.path.dirname(os.path.abspath(__file__))

import cpp
import python
from blur.build import *
import blur.build

# Setup config file replacements, could read from multiple files or a more
# dynamic system if needed(database)
blur.build.Config_Replacement_File = os.path.join(path,'config_replacements.ini')

All_Targets.append( RPMTarget('blurperlrpm','blur-perl',os.path.join(path,'perl'),'../rpm/spec/blur-perl.spec.template','1.0') )

All_Targets.append( Target('allrpms',os.path.abspath(os.getcwd()),[
		"stonerpm","stoneguirpm","classmakerrpm","classesrpm","pystonerpm","pyclassesrpm",
		"perlqtrpm","blurperlrpm","joberrorhandlerrpm","rrdstatscollectorrpm",
		"classesuirpm", "libassfreezerrpm", "assfreezerrpm", "blurpythonrpm", 'abscriptsrpms',
		"libabsubmitrpm", "assburnerrpm"]) )

if __name__ == "__main__":
	build()

