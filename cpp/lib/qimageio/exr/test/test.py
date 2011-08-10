
from PyQt4.QtGui import *
import sys

app = QApplication([])
img = QImage('test.exr')
if img.isNull():
	print "Unable to load exr"
lbl = QLabel(None)
lbl.setPixmap( QPixmap.fromImage(img) )
lbl.show()
app.exec_()
