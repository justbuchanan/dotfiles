#!/bin/bash

# run ansible playbooks
ansible-playbook -i hosts main.yml -K $@

