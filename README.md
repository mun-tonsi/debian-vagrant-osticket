# Vagrant - Centos - Ansible - OsTicket and dev tools

## This project configures a Vagrant managed Oracle Linux 8 VM running OsTicket for development using Ansible for provisioning.

This differs slightly from a production instance in the following way:

* Runs over http instead of https to avoid installing certs and keys.
* Avoids using any production ssh keys.
* Has a process to disable all email account checking.
* Can configure and start a new osTicket instance (or)
* Can import from an existing database and filesystem backup.
* Does not include adding a cron job for email collection, it would be bad if your dev setup collected real email meant for prod.

## Prerequisites

Before running you will need to have done the following:

* If not already done so, install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and [Ansible](http://docs.ansible.com/intro_installation.html).

  Currently tested using Virtualbox 6.1.34, Vagrant 2.3.0, and Ansible 5.10.0 running from Ubuntu.

* Install the required Ansible roles: `$ ansible-galaxy install -r requirements.yml -p ./roles` View [here](requirements.yml).

* Download an Oracle Vagrant box, details [here](https://yum.oracle.com/boxes/).

  `vagrant box add oraclelinux/8 https://oracle.github.io/vagrant-projects/boxes/oraclelinux/8.json`

* Optionally install the following Vagrant plugins: 

  `vagrant plugin install vagrant-timezone`

  `vagrant plugin install vagrant-cachier` (n.b now need to install manually from https://github.com/kshlm/vagrant-cachier/tree/update-dnf-yum v1.2.2)

* Browse the ansible variables file [roles/perryk.osticket.provision.dev/vars/main/yml](roles/perryk.osticket.provision.dev/vars/main.yml) to see if there is anything you would like to change.

* Browse the ansible provisioning scripts [playbook.yml](playbook.yml) and [roles/perryk.osticket.provision.dev/tasks/main.yml](roles/perryk.osticket.provision.dev/tasks/main.yml) to see if there is anything you would like to change.

* Set an entry in your hosts file to point 10.0.0.10 to osticket-dev . (optional)

  `10.0.0.10 osticket-dev`

* (Optional) Have an SQL dump of a working OsTicket database in a file named `database_to_import.sql` in the top level directory of this repo.

  If this database file does not exist, this will copy in the setup folder and sample config file to the webroot so setup can be manually done.

* (Optional) Have a zip backup of a working osTicket attachments folder in a file named `attachments_to_import.tgz` in the top level directory of this repo.

* (or if not importing a db) Manually complete setup by visiting `http://10.0.0.10/setup` AFTER the first `vagrant up` command as per below.

  After manually running setup, run the script `./vagrant_osticket_remove_setup.sh` to have the setup directory removed and the ost-config.php secured so it cannot be written any further.


## Running

The usual Vagrant commands will manage Vagrant:

`vagrant up`, to create a new VM, install the base box, and run the ansible script to provision it.

`vagrant ssh`, to log into it via SSH.

`vagrant destroy`, to delete the VM.

After a successfull "vagrant up", or after you have finsihed a manual setup, you should have fully installed and running OsTicket instance.

This has the latest source code from [osTicket](https://github.com/osticket/osticket). i.e from the develop branch, however this can be changed from the variable `osticket_repo_version` in the vars/main.yml of the deployment playbook.

If you wish to further modify the osTicket code, there is a script included which will pull a number of PRs and some branches from my own OsTicket fork.

Review this file prior to use, and use `./vagrant_osticket_modify_source.sh` to run it.

It is very likely this script will become out of date quickly so please use with care and check the PRs on the osTicket github site.

After a successful "vagrant ssh", it is possible to change to the service account with `sudo su - osticket` . This account can be used to edit the source and issue commands to the osTicket cli interface.

One such important command is used to deploy changes from the osTicket repo into the webroot. First `cd osTicket` to change directory to the source code, then perhaps `git pull` to obtain the latest files, then finally `./manage deploy /var/www/html/osticket` to update the webroot.

OsTicket plugins have been cloned into the `~/osTicket/include/plugins` folder also and similarly it is possible to change directory into these, pull changes, and then change directory back to `~/osTicket` before issuing the `./manage deploy /var/www/html/osticket` command again.

If you have imported a database from production it likely has email collection already configured and you will want to turn that off. Whilst cron is already missing, it is nice to have the extra reassurance that everything is turned off further. There is a script available which will set the database settings for each email account configured is set to disabled. Use `./vagrant_osticket_stop_email_collection.sh` to run it.

There is a script which will take an sql dump from a running vagrant instance and save the file as /tmp/vagrant_database_export.datetimestamp.sql. Use `./vagrant_osticket_dumpdb.sh` to run this.  Copy this file to this repo and rename it database_to_import.sql (or use a symlink) if you want later restore this dump.

There is a script which can quickly reload the database on the vagrant database without doing anything else. This needs a file named `database_to_import.sql` in the top level directory of this repo. Use `./vagrant_osticket_reloaddb.sh` to run it.

There is a script which will set a specific value to the SECRET_SALT variable. Use `./vagrant_osticket_set_salt.sh` to run this. This is useful when importing an attachments folder as this variable needs to match what is used from the previous setup.

Current default is to install Official MySQL server, however Mariadb can be used instead by setting the following variable to either mariadb or mysqld:




## Todo

* Modify the stop email collection script to instead change email settings so Mailhog is actually used. Mailhog will install and be running however and accessible from http://10.0.0.10:8025 . SMTP settings can be changed to localhost for the "Hostname" and 1025 for the "Port Number"

Might look at these also:

* [XDebug](https://github.com/geerlingguy/ansible-role-php-xdebug) if needing a full debugger. 

