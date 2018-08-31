# frozen_string_literal: true

require 'rails'

module DocomoNlu
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../templates', __dir__)
    def copy_initializer
      template 'docomo_nlu.rb', 'config/initializers/docomo_nlu.rb'
    end
  end
end
