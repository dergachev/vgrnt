#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# this Vagrantfile is including for testing purposes

Vagrant.configure("2") do |config|

  TEST_MULTI_VM = false

  if TEST_MULTI_VM
    config.vm.define :web do |web|
      web.vm.box = "precise64"
      config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    end
    config.vm.define :db do |web|
      web.vm.box = "precise64"
      config.vm.box_url = "http://files.vagrantup.com/precise64.box"
    end
  else
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

end
