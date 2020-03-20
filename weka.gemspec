# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weka/version'

Gem::Specification.new do |spec|
  spec.name          = 'weka'
  spec.version       = Weka::VERSION
  spec.authors       = ['Paul Götze']
  spec.email         = ['paul.christoph.goetze@gmail.com']

  spec.summary       = 'Machine Learning & Data Mining with JRuby.'
  spec.description   = 'A JRuby wrapper for the Weka library (http://www.cs.waikato.ac.nz/ml/weka/)'
  spec.homepage      = 'https://github.com/paulgoetze/weka-jruby'
  spec.license       = 'MIT'

  spec.platform               = 'java'
  spec.required_ruby_version  = '~> 2.0'

  spec.files         = Dir['**/{.*,*}'].reject { |f| f.match(%r{^((spec|jars|pkg)/|.*\.lock|lib/.*_jars\.rb)}) || File.directory?(f) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',          '~> 2.0'
  spec.add_development_dependency 'rake',             '~> 13.0'
  spec.add_development_dependency 'rspec',            '~> 3.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 4.0'

  spec.add_runtime_dependency 'jar-dependencies', '~> 0.4'
  spec.requirements << 'jar nz.ac.waikato.cms.weka, weka-dev, 3.9.4'
end
