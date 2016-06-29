# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tukune/version'

Gem::Specification.new do |spec|
  spec.name          = 'tukune'
  spec.version       = Tukune::VERSION
  spec.authors       = ['gin0606']
  spec.email         = ['kkgn06@gmail.com']

  spec.summary       = 'Create a pull request if there is a difference via Github API'
  spec.description   = 'Create a pull request if there is a difference via Github API'
  spec.homepage      = 'https://github.com/gin0606/tukune'
  spec.license = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'octokit'
  spec.add_dependency 'mem'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
end
