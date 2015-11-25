# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Loads environment vars
env_vars = File.join(Rails.root, 'config', 'env_vars.rb')
load(env_vars) if File.exists?(env_vars)

# Initialize the Rails application.
Rails.application.initialize!
