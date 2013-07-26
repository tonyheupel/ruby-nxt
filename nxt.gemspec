Gem::Specification.new do |spec|
  spec.name = 'nxt'
  spec.version = '0.5.0'
  spec.extra_rdoc_files = ['README.md']
  spec.summary = 'Control a Lego Minstorms NXT 2.0 Brick'
  spec.description = spec.summary + ' See http://github.com/tchype/ruby-nxt for more information.'
  spec.authors = ['Tony Heupel']
  spec.email = 'tony@heupel.net'
  spec.homepage = 'http://github.com/tchype/ruby-nxt'
  spec.files = %w(README.md) + Dir.glob('{lib,spec}/**/*')
  spec.require_path = 'lib'

  spec.add_dependency('serialport', '~>1.0.4')
  spec.add_development_dependency('guard-minitest', '~>0.5.0')
  spec.add_development_dependency('rb-fsevent', '~>0.9')
end
