import subprocess as proc
import os
from .commands import *


def deb_is_installed(pkgname):
    # TODO
    # return proc.call(['pacman', '-Q', pkgname],
    #                  stdout=proc.DEVNULL,
    #                  stderr=proc.DEVNULL) == 0
    return False


def pkg(pkgname):
    if not deb_is_installed(pkgname):
        print("Installing: %s" % pkgname)
        run_cmd(['sudo', 'apt', 'install', '-y', pkgname], stdout=proc.DEVNULL)
