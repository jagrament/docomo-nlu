require 'docomo_nlu/version'
require "docomo_nlu/config"
require 'activeresource'

module DocomoNlu
  autoload :Spontaneous,  'docomo_nlu/spontaneous'
  autoload :Management,   'docomo_nlu/management'
end
