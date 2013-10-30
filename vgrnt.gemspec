$:.unshift File.expand_path('../lib', __FILE__)
require 'vgrnt/version'

Gem::Specification.new do |spec|
  spec.name          = "vgrnt"
  spec.version       = Vgrnt::VERSION
  spec.authors       = "Alex Dergachev"
  spec.email         = "alex@evolvingweb.ca"
  spec.summary       = 'Speeds up a few common vagrant operations through dirty hacks.'
  spec.homepage      = 'https://github.com/dergachev/vgrnt'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path  = 'lib'

  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
