# frozen_string_literal: true

require 'bundler/setup'
require 'docomo-nlu'
require 'webmock/rspec'
require 'vcr'

def file_path(*paths)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', *paths))
end

module DocomoNlu
  module Test
    module MockFiles
      def stub_file(*filename)
        File.open(file_path(['management', filename]))
      end
    end
  end
end

RSpec.configure do |config|
  config.include DocomoNlu::Test::MockFiles

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'vcr/vcr_cassettes'
  config.hook_into :webmock
end
