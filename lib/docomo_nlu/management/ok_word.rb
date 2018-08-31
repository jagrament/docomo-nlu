# frozen_string_literal: true

module DocomoNlu
  module Management
    class OKWord < Base
      self.element_name = 'okWords'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
