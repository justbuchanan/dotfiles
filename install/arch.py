import subprocess as proc
import os

def pacman_is_installed(pkgname):
    return proc.call(['pacman', '-Q', pkgname], stdout=proc.DEVNULL, stderr=proc.DEVNULL) == 0

def archpkg(pkgname):
    if not pacman_is_installed(pkgname):
        print("Installing: %s" % pkgname)
        proc.check_call(['sudo', 'pacaur', '-S', '--noconfirm', pkgname],
            stdout=proc.DEVNULL)
