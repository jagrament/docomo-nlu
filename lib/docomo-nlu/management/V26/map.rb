# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Map < MultipartBase
      self.element_name = "maps"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"
    end
  end
end
