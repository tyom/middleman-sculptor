# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'middleman-sculptor/version'

Gem::Specification.new do |s|
  s.name = 'middleman-sculptor'
  s.version = Middleman::Sculptor::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tyom Semonov']
  s.email = ['mail@tyom.net']
  s.homepage = 'https://github.com/tyom/middleman-sculptor'
  s.summary = %q{Style guide generator for Middleman}
  s.description = %q{Generate style guides and static components in Middleman}
  s.license = 'MIT'

  s.files = `git ls-files -z`.split("\0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'middleman-core', '~> 3.3'
  s.add_dependency 'rest-client', '>= 1.7.3'
  s.add_dependency "nokogiri", [">= 1.6", "< 2.0"]
  s.add_dependency 'oj', '~> 2.10.2'
  s.add_dependency 'slim', '>= 3.0'
  s.add_dependency 'pry'
end
