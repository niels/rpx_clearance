require 'rake'
require 'rake/rdoctask'

desc 'Default: run tests.'
task :default => :test

require 'spec/rake/spectask'

desc 'Run all rpx_clearance plugin specs.'
Spec::Rake::SpecTask.new(:test) do |t|
  t.spec_opts = ['--options', "\"../../../spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end
  
  
desc 'Generate documentation for the rpx_clearance plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'RpxClearance'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8' 
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
