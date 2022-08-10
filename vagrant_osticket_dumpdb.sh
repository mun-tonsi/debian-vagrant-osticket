#!/bin/bash

export ANSIBLE_CONFIG=ansible_to_vagrant_instance.cfg

ansible-playbook -v vagrant_osticket_dumpdb.yml

