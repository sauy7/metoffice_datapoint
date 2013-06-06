# -*- encoding: utf-8 -*-
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/metoffice_datapoint'
  t.test_files = FileList['test/lib/**/*_test.rb']
  t.verbose = false
end

task :default => :test

desc "Run tests with code coverage"
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task["test"].execute
end