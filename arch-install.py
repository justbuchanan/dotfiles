#!/usr/bin/env python3

import subprocess as proc
import os

from install.utils import *

if linux_os_name() == 'Arch Linux':
    print("Installing dotfiles for Arch Linux")
    import arch.install

print()
print("Installing common dotfiles")
import common.install
