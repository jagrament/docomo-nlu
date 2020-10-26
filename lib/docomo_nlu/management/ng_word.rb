# frozen_string_literal: true

module DocomoNlu
  module Management
    class NGWord < OKNGBase
      self.element_name = "ngWords"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"
      self.extention = ".ng"
    end
  end
end
