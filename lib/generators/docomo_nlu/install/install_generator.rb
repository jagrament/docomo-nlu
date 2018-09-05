# frozen_string_literal: true

module DocomoNlu
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../../templates', __dir__)

    desc 'Description: Copy docomo-nlu files to your application. please add your key to this file.'

    def copy_initializer
      copy_file 'template.rb', 'config/initializers/docomo-nlu.rb'
    end
  end
end
