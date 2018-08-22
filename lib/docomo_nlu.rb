require 'docomo_nlu/version'
require "docomo_nlu/config"
require 'activeresource'
require 'faraday'

module DocomoNlu
  autoload :Spontaneous,  'docomo_nlu/spontaneous'
  autoload :Management,   'docomo_nlu/management'
  autoload :Formats,      'docomo_nlu/formats'
end
