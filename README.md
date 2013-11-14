vgrnt [![Gem Version](https://badge.fury.io/rb/vgrnt.png)](http://badge.fury.io/rb/vgrnt) [![Build Status](https://travis-ci.org/dergachev/vgrnt.png)](https://travis-ci.org/dergachev/vgrnt)
=====

`vgrnt` is a partial reimplementation of a few `vagrant` operations that I
found to be unbearably slow in my typical usage. Here's a benchmark on my
quad-core 2013 MacBook Pro:

```bash
time vagrant status
#    real 0m2.895s

time vgrnt status
#    real 0m0.316s
```

This is achieved by naively reimplementing these commands, without requiring
superfluous gems. Given how ashamed I am of the ugly hacks involved, the name
`vgrnt` was chosen to be deliberately unpronouncable. If you must use it,
probably best to keep it to yourself.

## Usage

### vgrnt status

Same as `vagrant status` but faster. 

```
vgrnt status
```

Does its dirty work by sneaking around in your Vagrantfile and the `./.vagrant` directory.

### vgrnt ssh

Same as `vagrant ssh` but faster.

```
vgrnt ssh
vgrnt ssh vm-name   # supports multi-vm environments
vgrnt ssh -- ls /tmp  # extra ssh args after --
```

Will read `.vgrnt-sshconfig` file for SSH options, or try to
guess the options by shelling out to VBoxManage.


### vgrnt ssh-config

Runs `vgrnt ssh-config > .vgrnt-sshconfig`. Use this if `vgrnt ssh` doesn't
seem to work, because you have a non-standard setup.

```
vgrnt ssh-config
# =>    creates .vgrnt-sshconfig; will get picked up by 'vgrnt ssh'

vgrnt ssh-config vm-name  # supports multi-vm environments
```

### vgrnt vboxmanage 

Simplifies calling `VBoxManage` on the already created VM. Injects
the VM ID (eg 0398e43a-d35f-4c84-bc81-6807f5d11262) in the right spot. 

```
vgrnt vboxmanage showvminfo --details
# =>    equivalent to: VBoxManage showvminfo 0398e43a-d35f-4c84-bc81-6807f5d11262 --details

vgrnt vboxmanage vm-name showvminfo   # supports multi-vm environments
```

Certain [VBoxManage subcommands](https://github.com/dergachev/vgrnt/blob/master/docs/vboxmanage-irregular-commands.txt)
have irregular syntax, so you need to specify where
to inject the VM_ID token:

```
vgrnt vboxmanage metrics query VM_ID 
# =>    VBoxManage metrics query 0398e43a-d35f-4c84-bc81-6807f5d11262
```

## Installation

vgrnt *should not* be installed as a vagrant plugin. Instead, just install the gem:

    gem install vgrnt --no-rdoc --no-ri

vgrnt only works with Vagrant 1.1+ running on Linux/OSX, with the VirtualBox provider.

## Why is Vagrant slow?

Vagrant itself isn't actually slow. The lag is mostly as a result of popular
but poorly constructed plugins:

```bash
time vgrnt ssh -- '/bin/true'
#    real 0m0.387s

time vagrant ssh -- '/bin/true'
#    real 0m2.102s

for P in $(vagrant plugin list | awk '{print $1}' ) ; do 
  vagrant plugin uninstall $P
done
#    Uninstalling the 'vagrant-berkshelf' plugin...
#    Uninstalling the 'vagrant-cachier' plugin...
#    Uninstalling the 'vagrant-omnibus' plugin...

time vagrant ssh -- '/bin/true'
#    real 0m0.716s
```

In my case, the culprit is [vagrant-berkshelf eager-loading 
dependencies](https://github.com/RiotGames/vagrant-berkshelf/issues/101).
However, any vagrant plugins introduce lag, so perhaps Vagrant's plugin
architecture could be modified to make this less of a problem.

## Caveats

* At the moment, it requires OSX/Linux and Virtualbox.
* Only works from vagrant project root, not in a subfolder

## Todo

* Ipmlement `vgrnt reprovision`
  - roughly equivalent to running `vagrant ssh -- chef-solo /tmp...`
* Integrate `vagrant-vbox-snapshot` plugin.
* Simplify everything by using VAGRANT_NO_PLUGINS env variable
  - See https://github.com/mitchellh/vagrant/blob/master/lib/vagrant.rb#L179

## Development

To hack on this plugin, do the following:

```
# fork the repo to your account

# clone your fork, and create a feature branch to work on
git clone https://github.com/USERNAME/vgrnt.git
cd vgrnt
git checkout -b MY-NEW-FEATURE

# installs the vagrant gem, which is a dev dependency
bundle install

# hack on the plugin
vim lib/vgrnt/base.rb # or any other file

# test out your changes in the context of this repo
cd spec/acceptance/fixtures/simple
bundle exec vgrnt ssh -- 'ls /tmp'

# run ALL the tests (not just unit)
bundle exec rake acceptance:prepare  # spin up VMs to test against
bundle exec rake spec
bundle exec rake acceptance:clean  # destroy testing VMs

# commit, push, and do a pull-request
```

See [DEVNOTES.md](https://github.com/dergachev/vgrnt/blob/master/docs/DEVNOTES.md)
for the notes I compiled while developing this plugin.
