# Developer notes for vgrnt

## Packaging a gem

See https://github.com/dergachev/vagrant-vbox-snapshot/blob/master/DEVNOTES.md#pushing-out-a-new-release-of-the-gem

In the future, also consider this workflow:

```
git clone https://github.com/dergachev/vgrnt.git ~/code/vgrnt
cd ~/code/vgrnt

# after making code changes, increment version number, build the gem locally
vim lib/vgrnt/version.rb +/VERSION # increment version counter, eg to 0.0.3
rake build  # package the gem into ./pkg/vgrnt-0.0.3.gem

# install and test the gem locally
gem uninstall vgrnt
gem install pkg/vgrnt-0.0.3.gem
cd ~/code/screengif 
vgrnt ssh -- ls /

# commit and publish the gem
vim CHANGELOG.md      # add v0.0.3 details
git commit -m "Publishing v0.0.3" CHANGELOG.md lib/vgrnt/version.rb

rake release
git push --tags
```

## Creating a gem

* http://timelessrepo.com/making-ruby-gems
* http://asciicasts.com/episodes/245-new-gem-with-bundler

