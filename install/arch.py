
import subprocess as proc
import os

def pacman_is_installed(pkgname):
	return proc.call(['pacman', '-Q', pkgname]) == 0

def pacman(pkgname):
	if pacman_is_installed(pkgname):
		print("Installing: %s" % pkgname)
		proc.check_call('pacman -S %s' % pkgname)
