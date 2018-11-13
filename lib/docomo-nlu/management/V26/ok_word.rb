# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class OKWord < Base
      self.element_name = "okWords"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"
    end
  end
end
