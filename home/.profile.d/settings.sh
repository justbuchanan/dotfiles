#!/usr/bin/env bash

# vim as default editor
export EDITOR='vim'

export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
