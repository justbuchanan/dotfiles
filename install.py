#!/usr/bin/env python3

import subprocess as proc
import os

from install.utils import *


def pacman(pkgname):
	print("Installing: %s" % pkgname)
	proc.check_call('pacman -S %s' % pkgname)


import platform
if platform.release().endswith('ARCH'):
	print("Installing dotfiles for Arch Linux")
	import arch.install

print("Installing common dotfiles")
import common.install