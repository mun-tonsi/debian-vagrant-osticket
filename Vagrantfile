VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.box = "centos/7"
  #config.vm.box = "geerlingguy/centos8"
  config.vm.box = "oraclelinux/8"  
  config.vm.box_url = "https://oracle.github.io/vagrant-projects/boxes/oraclelinux/8.json"

  config.vm.provider :virtualbox do |v|
      v.name = "osticket-dev"
      v.memory = 4096
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  config.vm.hostname = "osticket-dev"
  config.vm.network :private_network, ip: "10.0.0.10"

  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
    #config.timezone.value = "Australia/Brisbane"
    #config.timezone.value = "+10:00"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
  # Configure cached packages to be shared between instances of the same base box.
  # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    # NFS configured below is optional
    #config.cache.synced_folder_opts = {
    #    type: :nfs,
    #    mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #}
  end 

  ## likely needed for EL 9
  #config.vm.provision "shell", inline: <<-SHELL
  #  dnf install NetworkManager-initscripts-updown
  #SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.become = true
    ansible.compatibility_mode = "2.0"
  end

  config.vm.provision :shell, inline: "echo OsTicket dev host provisioned @ http://10.0.0.10"

end
