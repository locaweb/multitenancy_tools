# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postgresql_tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'postgresql_tools'
  spec.version       = PostgresqlTools::VERSION
  spec.authors       = ['Lenon Marcel', 'Rafael Timbó', 'Lucas Nogueira',
                        'Rodolfo Liviero']
  spec.email         = ['lenon.marcel@gmail.com', 'rafaeltimbosoares@gmail.com',
                        'lukspn.27@gmail.com', 'rodolfoliviero@gmail.com']
  spec.summary       = 'Some tools for PostgreSQL schema handling'
  spec.description   = 'Some tools for PostgreSQL schema handling'
  spec.homepage      = 'https://code.locaweb.com.br/saas/postgresql_tools'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://gems.locaweb.com.br'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3.0'
end
