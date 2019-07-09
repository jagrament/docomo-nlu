# frozen_string_literal: true

module DocomoNlu
  module Management
    class NGWord < Base
      self.element_name = "ngWords"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"
    end
  end
end
