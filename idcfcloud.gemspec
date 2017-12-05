# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idcf/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'idcfcloud'
  spec.version       = Idcf::Cli::VERSION
  spec.authors       = ['IDC Frontier Inc.']
  spec.email         = []

  spec.summary       = 'IDCF Cli tools'
  spec.description   = 'IDCF Cli'
  spec.homepage      = 'https://www.idcfcloud.jp'
  spec.license       = 'MIT'

  spec.post_install_message = 'Please carry out \'init\' command.'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit', '~> 3.2', '>= 3.2.5'
  spec.add_development_dependency 'test-unit-notify', '~> 1.0', '>= 1.0.4'
  spec.add_development_dependency 'prmd'

  spec.add_dependency 'activemodel', '~> 4.2', '>= 4.2.3'
  spec.add_dependency 'activesupport', '~> 4.2', '>= 4.2.3'
  spec.add_dependency 'inifile', '~> 3.0', '>= 3.0.0'
  spec.add_dependency 'thor', '~> 0.19.4'
  spec.add_dependency 'builder', '~> 3.1'
  spec.add_dependency 'kosi', '~> 1.0', '>= 1.0.0'

  spec.add_dependency 'open_uri_redirections', '~> 0.2.1'
  spec.add_dependency 'idcf-faraday_middleware', '~> 0.0.2'
  spec.add_dependency 'idcf-json_hyper_schema', '~> 0.1.0'
  spec.add_dependency 'jsonpath', '~> 0.8.10'
  spec.add_dependency 'facter', '~> 2.5.1'
  spec.add_dependency 'CFPropertyList', '~> 2.3.5'
end
