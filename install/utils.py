import subprocess as proc
import os

def symlink_home(srcdir, path):
	print("symlinking: %s" % path)
	src = os.path.join(srcdir, path)
	dst = os.path.join(os.path.expanduser('~'), path)
	if os.path.exists(src):
		proc.check_call(['ln', '-sf', src, dst])
	else:
		print("Source file doesn't exist")
