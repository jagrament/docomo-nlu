# frozen_string_literal: true

require 'docomo-nlu/version'
require 'docomo-nlu/config'
require 'activeresource'
require 'faraday'

module DocomoNlu
  autoload :Spontaneous,  'docomo-nlu/spontaneous'
  autoload :Management,   'docomo-nlu/management'
end
