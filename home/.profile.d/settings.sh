
# vim as default editor
export EDITOR='vim'

export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# Ruby
#if which ruby > /dev/null && which gem > /dev/null; then
#    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
#fi
export PATH="/home/justin/.local/share/gem/ruby/3.0.0/bin:$PATH"

# Python
#export PATH="/opt/anaconda/bin:$PATH"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Nix
export PATH="$HOME/.nix-profile/bin:$PATH"
