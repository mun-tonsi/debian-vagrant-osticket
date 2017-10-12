# Vagrant - Centos - Ansible - OsTicket and dev tools

## This project allows vagrant to manage a Centos 7 VM running OsTicket for development using Ansible for provisioning.

This differs slightly from a production instance in the following way:

Runs over http instead of https to avoid installing certs and keys.
Avoids using any production ssh keys.  
Has a process to disable all email account checking. (yet to be implemented)

Might look at [Mailhog](https://github.com/geerlingguy/ansible-role-mailhog) if needing to test emails being sent.
Might look at [XDebug] (https://github.com/geerlingguy/ansible-role-php-xdebug) if needing a full debugger. 

## Prerequisites

Before running you will need to have done the following:

* If not already done so, install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and [Ansible](http://docs.ansible.com/intro_installation.html).

* Install the required Ansible roles: `$ ansible-galaxy install -r requirements.yml`

* Install the following Vagrant plugins: 

  `vagrant plugin install vagrant-timezone` (required)
  `vagrant plugin install vagrant-cachier` (optional, modify Vagrantfile if you don't wish to use)

* Browse the main ansible provisioning script `roles/perryk.osticket.provision.dev/tasks/main.yml` to see if there is anything you would like to change.

* Set an entry in your hosts file to point 10.0.0.10 to osticket-dev .

  `10.0.0.10 osticket-dev`

* (Optional but preferred) Have an SQL dump of a working OsTicket database in a file named database_to_import.sql in the top level directory of this repo.

  If this database file does not exist, this will copy in the setup folder and sample config file to the webroot so setup can be manually done.

  Manually complete setup by visiting `http://10.0.0.10/setup`

  After manually running setup please run the script `./ansible_vagrant_osticket_remove_setup.sh` to have the setup directory removed and the ost-config.php secured so it cannot be written any further.

* Browse the main ansible provisioning script `roles/perryk.osticket.provision.dev/tasks/main.yml` to see if there is anything you would like to change.

## Running

The usual vagrant commands will manage vagrant:

`vagrant up`, to create a new VM, install the base box, and run the ansible script to provision it.

`vagrant ssh`, to log into it via SSH.

`vagrant destroy`, to delete the VM.

## Todo

A process to disable all email checking or implement something like Mailhog for email testing.
A script to take an sql dump from the existing running instance and save as database_to_import.sql

