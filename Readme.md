# Vagrant - Centos - Ansible - OsTicket and dev tools

## This project allows vagrant to manage a Centos 7 VM running OsTicket for development using Ansible for Provisioning.

This differs slightly from a production instance in the following way:

Runs over http instead of https to avoid installing certs and keys.
Avoids using any production ssh keys.  
Has a process to disable all email account checking. 

Might look at this [Mailhog](https://github.com/geerlingguy/ansible-role-mailhog) if needing to test emails being sent.

## Prerequisites

Before running you will need to have done the following:

* If not already done so, install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and [Ansible](http://docs.ansible.com/intro_installation.html).

* Install required Ansible roles: `$ ansible-galaxy install -r requirements.yml`

## Running

The usual vagrant commands will manage vagrant:

`vagrant up`, to create a new VM, install the base box, and run the ansible script to provision it.

`vagrant ssh`, to log into it via SSH.

`vagrant destroy`, to delete the VM.

## Todo


