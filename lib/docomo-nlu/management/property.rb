# frozen_string_literal: true

module DocomoNlu
  module Management
    class Property < Base
      self.element_name = "properties"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
