VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   #config.vm.box = "centos/7"
  config.vm.box = "geerlingguy/centos7"

  config.vm.provider :virtualbox do |v|
      v.name = "osticket-dev"
      v.memory = 2048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.hostname = "osticket-dev"
  config.vm.network :private_network, ip: "10.0.0.10"

  if Vagrant.has_plugin?("vagrant-timezone")
    #config.timezone.value = :host
    config.timezone.value = "Australia/Brisbane"
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

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.become = true
  end

  config.vm.provision :shell, inline: "echo OsTicket dev host provisioned @ http://10.0.0.10"

end
