lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'

if RUBY_VERSION < '2.0.0'
  require 'sensu-simple-solr-plugins'
else
  require_relative 'lib/sensu-simple-solr-plugins'
end

Gem::Specification.new do |s|
  s.authors                = ['Dario Ferrer']

  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides 2 checks, Solr status and Solr slave slatus'
  s.email                  = '<dario@bashton.com>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w(README.md)
  s.homepage               = 'https://github.com/darioatbashton/sensu-simple-solr-plugins'
  s.license                = 'None'
  s.metadata               = { 'maintainer'         => 'Dario Ferrer',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-simple-solr-plugins'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 1.9.3'

  s.summary                = 'Sensu Simple solr plugins'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuSimpleSolrPlugins::Version::VER_STRING

  s.add_runtime_dependency 'sensu-plugin', '~> 1.2'
  s.add_runtime_dependency 'rest-client',       '1.8.0'

  s.add_development_dependency 'rspec',                     '~> 3.1'
  s.add_development_dependency 'bundler',                   '~> 1.7'
  s.add_development_dependency 'rake',                      '~> 10.0'
end
