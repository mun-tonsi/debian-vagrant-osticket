# Vagrant - Centos - Ansible - OsTicket and dev tools

## This project configures a Vagrant managed Centos 7 VM running OsTicket for development using Ansible for provisioning.

This differs slightly from a production instance in the following way:

* Runs over http instead of https to avoid installing certs and keys.
* Avoids using any production ssh keys.
* Has a process to disable all email account checking. (working however is a manual step)
* Does not include adding a cron job for email collection, it would be bad if your dev setup collected real email meant for prod.

## Prerequisites

Before running you will need to have done the following:

* If not already done so, install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and [Ansible](http://docs.ansible.com/intro_installation.html).

  Currently tested using Virtualbox 5.1.22, Vagrant 2.0.0, and Ansible 2.4.0.0 running from Ubuntu.

* Install the required Ansible roles: `$ ansible-galaxy install -r [`requirements.yml`](requirements.yml)`

* Download this Vagrant box which has virtualbox guest extensions already installed.

  `vagrant box add "geerlingguy/centos7"`

* Install the following Vagrant plugins: 

  `vagrant plugin install vagrant-timezone` (required)

  `vagrant plugin install vagrant-cachier` (optional, modify [Vagrantfile](Vagrantfile) if you don't wish to use)

* Browse the ansible variables file here [`roles/perryk.osticket.provision.dev/vars/main/yml`](roles/perryk.osticket.provision.dev/vars/main/yml) to see if there is anything you would like to change.

* Browse the ansible provisioning scripts [`playbook.yml`](playbook.yml) and [`roles/perryk.osticket.provision.dev/tasks/main.yml`](roles/perryk.osticket.provision.dev/tasks/main.yml) to see if there is anything you would like to change.

* Set an entry in your hosts file to point 10.0.0.10 to osticket-dev . (optional)

  `10.0.0.10 osticket-dev`

* (Optional but preferred) Have an SQL dump of a working OsTicket database in a file named `database_to_import.sql` in the top level directory of this repo.

  If this database file does not exist, this will copy in the setup folder and sample config file to the webroot so setup can be manually done.

  Manually complete setup by visiting `http://10.0.0.10/setup` AFTER the first `vagrant up` command as per below.

  After manually running setup please run the script `./ansible_vagrant_osticket_remove_setup.sh` to have the setup directory removed and the ost-config.php secured so it cannot be written any further.


## Running

The usual Vagrant commands will manage Vagrant:

`vagrant up`, to create a new VM, install the base box, and run the ansible script to provision it.

`vagrant ssh`, to log into it via SSH.

`vagrant destroy`, to delete the VM.

After a successfull "vagrant up", or after you have finsihed a manual setup, you should have fully installed and running OsTicket instance.

This has the latest source code from [osTicket](https://github.com/osticket/osticket).

If you wish to further modify the osTicket code, there is a script included which will pull a number of PRs and some branches from my own OsTicket fork.

Review this file prior to use, and use [`./vagrant_osticket_modify_source.sh`](vagrant_osticket_modify_source.sh) to run it.

It is very likely this script will become out of date quickly so please use with care and check the PRs on the osTicket github site.

After a successful "vagrant ssh", it is possible to change to the service account with `sudo su - osticket` . This account can be used to edit the source and issue commands to the osTicket cli interface.

One such important command is used to deploy changes from the osTicket repo into the webroot. First `cd osTicket` to change directory to the source code, then perhaps `git pull` to obtain the latest files, then finally `./manage deploy /var/www/html/osticket` to update the webroot.

OsTicket plugins have been cloned into the `~/osTicket/include/plugins` folder also and similarly it is possible to change directory into these, pull changes, and then change directory back to `~/osTicket` before issuing the `./manage deploy /var/www/html/osticket` command again.

If you have imported a database from production it likely has email collection already configured and you will want to turn that off. Whilst cron is already missing, it is nice to have the extra reassurance that everything is turned off further. There is a script available which will set the database settings for each email account configured is set to disabled. Use [`./vagrant_osticket_stop_email_collection.sh`](vagrant_osticket_stop_email_collection.sh) to run it.

## Todo

A script to change email settings so Mailhog is actually used. Currently it is setup and available from http://10.0.0.10:8025 however.

A script to take an sql dump from the existing running instance and save as database_to_import.sql .

Might look at these also:

* [XDebug](https://github.com/geerlingguy/ansible-role-php-xdebug) if needing a full debugger. 

