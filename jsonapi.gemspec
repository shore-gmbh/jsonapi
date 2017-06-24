lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'jsonapi'
  spec.version       = Jsonapi::VERSION
  spec.authors       = ['Thiago Rodrigues de Paula']
  spec.email         = ['contact@shore.com']

  spec.summary       = 'A clean implementation o jsonapi serializers.'
  spec.description   = 'A clean implementation o jsonapi serializers.'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
