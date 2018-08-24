require "rails"

module DocomoNlu
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("../templates", __dir__)
    def copy_initializer
      template "docomo_nlu.rb", "config/initializers/devise.rb"
    end
  end
end
