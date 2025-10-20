
# vim as default editor
export EDITOR='vim'

export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# Python
#export PATH="/opt/anaconda/bin:$PATH"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Nix
export PATH="$HOME/.nix-profile/bin:$PATH"
