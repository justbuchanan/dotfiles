
import subprocess as proc
import os

def pacman(pkgname):
	print("Installing: %s" % pkgname)
	proc.check_call('pacman -S %s' % pkgname)
