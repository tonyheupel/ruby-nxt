Gem::Specification.new do |spec|
  spec.name = 'nxt'
  spec.version = '0.5.0'
  spec.extra_rdoc_files = ['README.md']
  spec.summary = 'Control an NXT 2.0'
  spec.description = spec.summary + ' See http://github.com/tchype/ruby-nxt2 for more information.'
  spec.authors = ['Tony Heupel']
  spec.email = 'tony@heupel.net'
  spec.homepage = 'http://github.com/tchype/ruby-nxt2'
  spec.files = %w(README.md LICENSE) + Dir.glob('{lib,spec}/**/*')
  spec.licenses = 'MIT LICENSE'
  spec.require_path = 'lib'

  spec.add_dependency('serialport', '~>1.0.4')
end
