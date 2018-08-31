# frozen_string_literal: true

require 'active_support/configurable'
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
    config.nlu_host = 'http://nlu-external-dev-977165653.ap-northeast-1.elb.amazonaws.com'
    config.nlu_version = 'v2.2'
    config.admin_access_token = 'NLP f68518ed5a40907ec6b754caeaadc32b0af4920f69955c22749e38e17946ea57'
  end
end
