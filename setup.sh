#!/bin/bash

# update submodules
git submodule update --init --recursive

# run ansible playbooks
ansible-playbook -i hosts main.yml -K $@

