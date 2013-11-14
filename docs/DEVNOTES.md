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

## Nov 6 2013 - Notes on rspec

Ruby:

* http://stackoverflow.com/questions/2232/calling-bash-commands-from-ruby

How to write a test:

* https://github.com/dergachev/rspec-tutorial/blob/master/spec/acceptance/rspec_tutorial_spec.rb
* http://blog.davidchelimsky.net/blog/2012/05/13/spec-smell-explicit-use-of-subject/
* http://betterspecs.org/

Rspec features:

* https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
* https://www.relishapp.com/rspec/rspec-core/v/2-0/docs/hooks/before-and-after-hooks

Setting up the rake spec tasks:

* https://www.relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option#filter-examples-with-a-simple-tag-and-@
* https://github.com/fgrehm/vagrant-lxc/blob/master/spec/acceptance_helper.rb
* https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task
* https://github.com/fgrehm/vagrant-lxc/blob/master/tasks/spec.rake
