
set -o vi	#	vi-style keyboard shortcuts for bash


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# source all files in .profile.d
for i in ~/.profile.d/*.sh ; do
    if [ -r "$i" ]; then
        . $i
    fi
done


# added by travis gem
[ -f /home/justbuchanan/.travis/travis.sh ] && source /home/justbuchanan/.travis/travis.sh
[ -f /opt/mambaforge/etc/profile.d/conda.sh ] && source /opt/mambaforge/etc/profile.d/conda.sh
