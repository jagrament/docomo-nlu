# frozen_string_literal: true

require "active_support/configurable"
module DocomoNlu
  def self.configure
    yield @config ||= DocomoNlu::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :nlu_host
    config_accessor :nlu_version
    config_accessor :admin_access_token
  end

  configure do |config|
    config.nlu_host = ENV["NLU_HOST"]
    config.nlu_version = ENV["NLU_VERSION"]
    config.admin_access_token = ENV["NLU_ADMIN_ACCESS_TOKEN"]
  end
end
