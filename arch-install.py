#!/usr/bin/env python3

import subprocess as proc
import os

from install.utils import *


def pacman(pkgname):
	print("Installing: %s" % pkgname)
	proc.check_call('pacman -S %s' % pkgname)

import arch.install
import common.install