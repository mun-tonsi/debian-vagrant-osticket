#!/bin/bash

export ANSIBLE_CONFIG=ansible_to_vagrant_instance.cfg

ansible-playbook vagrant_osticket_modify_source.yml

