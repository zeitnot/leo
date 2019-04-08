require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
]

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/lib/leo/version.rb'
  
  track_files 'lib/**/*.rb'
  coverage_dir 'coverage'
end

require 'bundler/setup'
require 'leo'
require 'webmock/rspec'

Dir[Dir.pwd + '/spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
