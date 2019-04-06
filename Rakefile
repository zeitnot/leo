# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'reek/rake/task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

Reek::Rake::Task.new do |t|
  t.config_file   = '.reek.yml'
  t.source_files  = '**/*.rb'
  t.verbose       = true
end

desc 'Runs rubocop to analyze code statically'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

desc 'Pre-push checks'
task :checks do
  Rake::Task['spec'].invoke
  Rake::Task['rubocop'].invoke
  Rake::Task['reek'].invoke
  `open log/coverage/index.html`
end
