#!/usr/bin/env python

from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *

import sys, signal

# needed for ctrl+c to kill the program
signal.signal(signal.SIGINT, signal.SIG_DFL)

app = QApplication(sys.argv)
win = QMainWindow()
win.setAttribute(Qt.WA_TranslucentBackground)
win.show()
app.exec()
