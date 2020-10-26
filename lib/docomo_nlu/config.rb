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
    config.nlu_host = "http://nlu26-external-dev-857907527.ap-northeast-1.elb.amazonaws.com"
    config.nlu_version = "v2.6"
    config.admin_access_token = "NLP ZDVjODZlOTA2ZmZlYjVhOTFmNWFjODlmNDE1NTUwYTBhYjc0MzJhZDcyZmU1YTU4YTkxNGNkOWJmNjMzOTE5MQ=="
  end
end
