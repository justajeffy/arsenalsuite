from blur.build import *
import os

path = os.path.dirname(os.path.abspath(__file__))

if sys.platform != 'win32':
    abscriptInstallCmd = "bash " + path + "/installScripts.sh"
else:
    abscriptInstallCmd = " " # to do

abscriptTarget = StaticTarget("abscripts",path,abscriptInstallCmd,[],shell=True)

if __name__ == "__main__":
    build()
