#!/usr/bin/env python3

import subprocess as proc
import os

from install.utils import *

import platform
if platform.release().endswith('ARCH'):
	print("Installing dotfiles for Arch Linux")
	import arch.install

print()
print("Installing common dotfiles")
import common.install