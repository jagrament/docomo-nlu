# frozen_string_literal: true

module DocomoNlu
  module Management::V23
    class Property < Base
      self.element_name = "properties"
      self.prefix = "/management/v2.2/projects/:project_id/bots/:bot_id/"
    end
  end
end
