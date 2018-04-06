# frozen_string_literal: true

Vagrant.configure('2') do |config|
  config.vm.box = 'generic/debian9'
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.synced_folder '.', '/home/vagrant/app'
  config.ssh.forward_agent = true
  config.vbguest.auto_update = false

  config.vm.provision 'shell',
                      privileged: false,
                      path: 'script/provision-vagrant.sh'
end
