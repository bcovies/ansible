#!/bin/bash

sudo apt-get update -y

sudo apt-get install ansible -y

ansible-playbook ./provisioning.yml -bK