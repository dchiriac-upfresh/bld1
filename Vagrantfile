Vagrant.configure("2") do |config|

  config.vm.define :builder, autostart: true do |master_config|

    master_config.vm.box = "centos-7.0"
    master_config.vm.box_url = "https://atlas.hashicorp.com/bento/boxes/centos-7.1/versions/2.2.2/providers/virtualbox.box"
    master_config.vm.host_name = 'builder.local'

    master_config.vm.provision :shell do |shell|
      privileged = true
      shell.path = "vagrant/setup_rbenv.sh"
    end

    master_config.vm.provision :shell do |shell|
      privileged = true
      shell.path = "vagrant/setup_builder.sh"
    end
  end

end
