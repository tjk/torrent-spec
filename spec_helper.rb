RSpec.configure do |config|
  config.color = true
  config.add_formatter 'documentation'
  config.warnings = true
  config.profile_examples = 5
  config.order = :random

  Kernel.srand(config.seed)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

require_relative './lib/client_runner.rb'
require_relative './lib/tracker_mock.rb'
require_relative './lib/util.rb'
