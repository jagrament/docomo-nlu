require "bundler/setup"
require "docomo_nlu"
require "webmock/rspec"

def file_path( *paths )
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', *paths))
end

module DocomoNlu
  module Test
    module MockFiles
      def stub_file(filename, mime_type=nil, fake_name=nil)
        File.open(file_path(filename))
      end
    end
  end
end

RSpec.configure do |config|

  config.include DocomoNlu::Test::MockFiles

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
