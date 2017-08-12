import subprocess as proc
import os
from .commands import *


def pacman_is_installed(pkgname):
    return proc.call(['pacman', '-Q', pkgname],
                     stdout=proc.DEVNULL,
                     stderr=proc.DEVNULL) == 0


def archpkg(pkgname):
    if not pacman_is_installed(pkgname):
        print("Installing: %s" % pkgname)
        run_cmd(['pacaur', '-S', '--noconfirm', pkgname], stdout=proc.DEVNULL)
