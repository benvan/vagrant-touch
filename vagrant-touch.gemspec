# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-touch/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-touch"
  spec.version       = Vagrant::Touch::VERSION
  spec.authors       = ["Ben van Enckevort"]
  spec.email         = ["vagrant-touch@gmail.com"]

  spec.summary       = "Triggers FS events in synced_folder (workaround for poor VirtualBox nfs+libnotify support)"
  spec.homepage      = "https://github.com/benvan/vagrant-touch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
