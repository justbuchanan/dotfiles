import subprocess as proc
import os
import errno

def symlink_home(srcdir, path):
    # print("symlinking: %s" % path)
    src = os.path.join(srcdir, path)
    dst = os.path.join(os.path.expanduser('~'), path)
    if os.path.exists(src):
        try:
            if os.path.islink(dst) and os.readlink(dst) == src:
                # print('Already linked')
                pass
            else:
                mkdir_p(os.path.dirname(dst))
                proc.check_call(['ln', '-sf', src, dst])
        except OSError as e:
            print("Unable to link '%s'\n    %s" % (path, str(e)))
    else:
        print("Source file doesn't exist")

# borrowed from stack overflow:
# http://stackoverflow.com/questions/16029871/how-to-run-os-mkdir-with-p-option-in-python
def mkdir_p(dirpath):
    try:
        os.makedirs(dirpath)
    except OSError as exc: 
        if exc.errno == errno.EEXIST and os.path.isdir(dirpath):
            pass
