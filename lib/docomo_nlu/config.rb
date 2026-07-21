# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/class/attribute"
module DocomoNlu
  def self.configure
    # @config is shared with .config below, not scoped to this method
    yield @config ||= DocomoNlu::Configuration.new # rubocop:disable Naming/MemoizedInstanceVariableName
  end

  def self.config
    @config
  end

  class Configuration
    class_attribute :nlu_host
    class_attribute :nlu_version
    class_attribute :admin_access_token
  end

  configure do |config|
    config.nlu_host = ENV["NLU_HOST"]
    config.nlu_version = ENV["NLU_VERSION"]
    config.admin_access_token = ENV["NLU_ADMIN_ACCESS_TOKEN"]
  end
end
