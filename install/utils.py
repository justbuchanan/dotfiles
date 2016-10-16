import subprocess as proc
import os
import sys
import errno
import re
from . import arch


# determine if the system has a graphical interface
def linux_is_graphical():
    return 'DISPLAY' in os.environ


def linux_os_name():
    try:
        with open('/etc/os-release', 'r') as f:
            os_release = f.read()
        return re.match("NAME=\"([^\"]+)\"", os_release).group(1)
    except:
        return None


def symlink_home(srcdir, path):
    src = os.path.join(srcdir, path)
    dst = os.path.join(os.path.expanduser('~'), path)
    if os.path.exists(src):
        try:
            if not os.path.islink(dst) or os.readlink(dst) != src:
                print("symlinking: %s" % path)
                mkdir_p(os.path.dirname(dst))
                proc.check_call(['ln', '-sf', src, dst])
        except OSError as e:
            print("Unable to link '%s'\n    %s" % (path, str(e)),
                  file=sys.stderr)
    else:
        print("Source file doesn't exist: %s" % src)

# example: symlink(__file__, 'myconfig', '~/.config/app/config')
def symlink(py_file, relpath, dst):
    base_dir = os.path.dirname(os.path.realpath(py_file))
    src = os.path.join(base_dir, relpath)
    absdst = os.path.expanduser(dst)
    if os.path.exists(src):
        try:
            if not os.path.islink(absdst) or os.readlink(absdst) != src:
                print("symlinking: %s" % dst)
                mkdir_p(os.path.dirname(absdst))
                proc.check_call(['ln', '-sf', src, absdst])
        except OSError as e:
            print("Unable to link '%s'\n    %s" % (dst, str(e)),
                  file=sys.stderr)
    else:
        print("Source file doesn't exist: %s" % src)


# borrowed from stack overflow:
# http://stackoverflow.com/questions/16029871/how-to-run-os-mkdir-with-p-option-in-python
def mkdir_p(dirpath):
    try:
        os.makedirs(dirpath)
    except OSError as exc:
        if exc.errno == errno.EEXIST and os.path.isdir(dirpath):
            pass

def pip2(pkgname):
    proc.check_call(['sudo', 'pip2', 'install', pkgname], stdout=proc.DEVNULL)

def pip3(pkgname):
    proc.check_call(['sudo', 'pip3', 'install', pkgname], stdout=proc.DEVNULL)


def apm(pkgname):
    proc.check_call(['apm', 'install', pkgname], stdout=proc.DEVNULL)


def syspkg(pkgmap):
    if 'arch' in pkgmap:
        for pkg in pkgmap['arch']:
            arch.archpkg(pkg)
    # TODO: add homebrew, ubuntu, etc
