# frozen_string_literal: true

module DocomoNlu
  module Management
    class OKWord < OKNGBase
      self.element_name = "okWords"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"
      self.extention = ".ans"
    end
  end
end
