# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'comandor/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.3'
  spec.name          = 'comandor'
  spec.version       = Comandor::VERSION
  spec.authors       = ['Renat Ibragimov']
  spec.email         = ['mrak69@gmail.com']

  spec.summary       = 'Comandor - simple service objects in Ruby'
  spec.description   = 'A simple Service Objects in Ruby'
  spec.homepage      = 'https://github.com/mpakus/comandor'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'pry', '~> 0.10'
end
