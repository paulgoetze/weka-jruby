$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'weka'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FileHelpers
  config.include InstancesHelpers

  config.after(:all) { remove_temp_dir }
end
