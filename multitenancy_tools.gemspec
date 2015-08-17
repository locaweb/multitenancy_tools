# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multitenancy_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'multitenancy_tools'
  spec.version       = MultitenancyTools::VERSION
  spec.authors       = ['Lenon Marcel', 'Rafael Timbó', 'Lucas Nogueira',
                        'Rodolfo Liviero']
  spec.email         = ['lenon.marcel@gmail.com', 'rafaeltimbosoares@gmail.com',
                        'lukspn.27@gmail.com', 'rodolfoliviero@gmail.com']
  spec.summary       = 'A collection of tools for multitenant Ruby/Rails apps'
  spec.description   = 'A collection of tools for multitenant Ruby/Rails apps'
  spec.homepage      = 'https://github.com/locaweb/multitenancy_tools'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_development_dependency 'activerecord', '~> 4.2.0'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'pry'
end
