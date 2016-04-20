import subprocess as proc
import os

def symlink_home(srcdir, path):
    print("symlinking: %s" % path)
    src = os.path.join(srcdir, path)
    dst = os.path.join(os.path.expanduser('~'), path)
    if os.path.exists(src):
        try:
            if os.readlink(dst) == src:
                print('Already linked')
            else:
                proc.check_call(['ln', '-sf', src, dst])
        except OSError as e:
            print("Unable to link '%s'" % path)
    else:
        print("Source file doesn't exist")
