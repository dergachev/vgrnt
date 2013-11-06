vgrnt [![Gem Version](https://badge.fury.io/rb/vgrnt.png)](http://badge.fury.io/rb/vgrnt) [![Build Status](https://travis-ci.org/dergachev/vgrnt.png)](https://travis-ci.org/dergachev/vgrnt)
=====



`vgrnt` is a partial reimplementation of a few `vagrant` operations that I
found to be unbearably slow. For example:

```bash
time vagrant ssh -- '/bin/true'
#    real  0m1.969s

time vgrnt ssh -- '/bin/true'
#    real  0m0.538s
```

It achieves this by naively reimplementing these commands, without requiring
superfluous gems (not even vagrant) or parsing the Vagrantfile. Given how
ashamed I am of such ugly hacks, the name `vgrnt` was chosen to be deliberately
unpronouncable. If you must use it, probably best to keep it to yourself.


## vgrnt ssh

Same as `vagrant ssh` but faster. Will read `.vgrnt-sshconfig` file for SSH options, or try to
guess the options by shelling out to VBoxManage.

```
vgrnt ssh
vgrnt ssh vm-name   # supports multi-vm environments
vgrnt ssh -- ls /tmp  # extra ssh args after --
```

## vgrnt ssh-config

Runs `vgrnt ssh-config > .vgrnt-sshconfig`. Use this if `vgrnt ssh` doesn't
seem to work, because you have a non-standard setup.

```
vgrnt ssh-config
# =>    creates .vgrnt-sshconfig; will get picked up by 'vgrnt ssh'

vgrnt ssh-config vm-name  # supports multi-vm environments
```

## vgrnt vboxmanage 

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

## TODO

* vgrnt status (can pull it out from vboxmanage)
* vgrnt reprovision (equivalent to running `vagrant ssh -- chef-solo /tmp...`
* vgrnt destroy (how hard is it to kill a VM??)
* vgrnt snapshot (it's currently implemented as a vagrant plugin, but who needs decoupling?)

## Caveats


* At the moment, it requires OSX/Linux and Virtualbox.
* Only works from vagrant project root, not in a subfolder
* Tests, what tests?

## Installation

vgrnt *should not* be installed as a vagrant plugin. Instead, simply
Ensure you have Vagrant 1.1+ installed, then run:

    gem install vgrnt --no-rdoc --no-ri


## Development

To develop on this plugin, do the following:

```
# get the repo, and then make a feature branch (REPLACE WITH YOUR FORK)
git clone https://github.com/dergachev/vagrant-vboxmanage.git
cd vagrant-vboxmanage
git checkout -b MY-NEW-FEATURE

# installs the vagrant gem, which is a dev dependency
bundle install 

# hack on the plugin
vim lib/vagrant-vboxmanage.rb # or any other file

# test out your changes, in the context provided by the development vagrant gem, and the local Vagrantfile.
bundle exec vagrant snapshot ...

# commit, push, and do a pull-request
```

See [DEVNOTES.md](https://github.com/dergachev/vagrant-vboxmanage/blob/master/DEVNOTES.md)
for the notes I compiled while developing this plugin.
