# vi-style keyboard shortcuts for bash
set -o vi

# source all files in .profile.d
for i in ~/.profile.d/*.sh ; do
    if [ -r "$i" ]; then
        . $i
    fi
done
