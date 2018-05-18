# frozen_string_literal: true
require 'yaml'

def cpu_count
  host = RbConfig::CONFIG['host_os']
  # Give VM access to all cpu cores on the host
  if host =~ /darwin/
    `sysctl -n hw.ncpu`.to_i
  elsif host =~ /linux/
    `nproc`.to_i
  else # sorry Windows folks, I can't help you
    1
  end
end

DEFAULTS = {
  'box' => 'debian/contrib-stretch64',
  'memory' => 1536,
  'cpus' => cpu_count,
  'ip' => nil
}

settings_file_path = File.dirname(__FILE__) + '/.vagrant.yml'
settings_file = if File.exist?(settings_file_path)
  YAML.load(File.read(settings_file_path))
else
  {}
end

SETTINGS = DEFAULTS.merge(settings_file).freeze

Vagrant.configure('2') do |config|
  config.vm.box = SETTINGS['box']

  if SETTINGS['ip']
    config.vm.network :private_network, ip: SETTINGS['ip']
  else
    config.vm.network :forwarded_port, guest: 3000, host: 3000
  end

  config.vm.synced_folder '.', '/home/vagrant/app'
  config.ssh.forward_agent = true
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', SETTINGS['memory']]
    vb.customize ['modifyvm', :id, '--cpus', SETTINGS['cpus']]
  end

  config.vm.provision 'shell',
                      privileged: false,
                      path: 'script/provision-vagrant.sh'

  config.vm.post_up_message = <<~EOT
    Log into the Vagrant box with \`vagrant ssh\`
      Run the test suite by \`./bin/rake\`
      Start Rails server by \`./bin/rails server\`
      Start all app processes with \`shoreman\`
    Access the site at http://0.0.0.0:3000.
  EOT
end
