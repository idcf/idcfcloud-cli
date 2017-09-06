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

  spec.add_dependency 'test-unit', '~> 3.2', '>= 3.2.5'
  spec.add_dependency 'test-unit-notify', '~> 1.0', '>= 1.0.4'

  spec.add_dependency 'activerecord', '~> 4.2', '>= 4.2.3'
  spec.add_dependency 'activesupport', '~> 4.2', '>= 4.2.3'
  spec.add_dependency 'inifile', '~> 3.0', '>= 3.0.0'
  spec.add_dependency 'thor', '~> 0.19.4'
  spec.add_dependency 'builder', '~> 3.1'
  spec.add_dependency 'kosi', '~> 1.0', '>= 1.0.0'

  spec.add_runtime_dependency 'idcf-your'
  spec.add_runtime_dependency 'idcf-faraday_middleware'
  spec.add_runtime_dependency 'idcf-ilb', '>= 0.0.3'
end
