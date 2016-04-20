import subprocess as proc
import os

def symlink_home(path):
	print("symlinking: %s" % path)
	src = "%s" % path
	if os.path.exists(src):
		proc.check_call(['ln', '-sf', src, os.path.expanduser('~')])
	else:
		print("Source file doesn't exist")
