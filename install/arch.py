
import subprocess as proc
import os

def pacman_is_installed(pkgname):
	return proc.call(['pacman', '-Q', pkgname]) == 0

def pacman(pkgname):
	if not pacman_is_installed(pkgname):
		print("Installing: %s" % pkgname)
		proc.check_call(['sudo', 'pacman', '-S', '--noconfirm', pkgname], stdout=proc.devnull)

def yaourt(pkgname):
    if not pacman_is_installed(pkgname):
        print("Installing: %s" % pkgname)
        proc.check_call('yaourt -S %s' % pkgname)
    else:
        print("Already installed: %s" % pkgname)
