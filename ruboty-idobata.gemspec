# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/idobata/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-idobata"
  spec.version       = Ruboty::Idobata::VERSION
  spec.authors       = ["Seiei Higa"]
  spec.email         = ["hanachin@gmail.com"]
  spec.summary       = %q{Idobata adapter for Ruboty.}
  spec.homepage      = "https://github.com/yasslab/ruboty-idobata"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.1.0"
  spec.add_dependency "ruboty"
  spec.add_dependency "pusher-client"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
