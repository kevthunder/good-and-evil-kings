ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  setup :load_seeds

  protected 

    def load_seeds
      Updater.before_every_actions = false
      load "#{Rails.root}/db/seeds.rb"
    end
end

class ActionController::TestCase
  include Devise::TestHelpers
end
