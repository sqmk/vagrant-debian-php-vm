Vagrant.configure("2") do |config|

  config.vm.box = "debian-php-dev"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-607-x64-vbox4210.box"

  config.vm.hostname = "php-dev-vm"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :private_network, ip: "33.33.33.10"
  config.vm.network :public_network, :bridge => 'en1: Wi-Fi (AirPort)'

  config.vm.synced_folder "app/", "/app", :nfs => true

  config.vm.provision :puppet

end