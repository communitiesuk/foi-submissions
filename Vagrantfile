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
  'box' => 'generic/debian9',
  'memory' => 1536,
  'cpus' => cpu_count
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
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.synced_folder '.', '/home/vagrant/app'
  config.ssh.forward_agent = true
  config.vbguest.auto_update = false

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['modifyvm', :id, '--memory', SETTINGS['memory']]
    vb.customize ['modifyvm', :id, '--cpus', SETTINGS['cpus']]
  end

  config.vm.provision 'shell',
                      privileged: false,
                      path: 'script/provision-vagrant.sh'
end
