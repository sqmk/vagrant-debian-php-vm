Vagrant.configure("2") do |config|

  config.vm.box = "debian-php-dev"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

  config.vm.hostname = "php-dev.example.com"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "192.168.1.121"

  config.vm.synced_folder "app/", "/app", :nfs => true

  config.vm.provision :puppet do |puppet|
  	puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
  	puppet.module_path = "modules"
  	puppet.options = "--hiera_config /vagrant/config/hiera.yaml"
  end

end
