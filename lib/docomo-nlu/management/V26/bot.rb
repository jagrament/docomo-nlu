# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Bot < AIMLBase
      self.element_name = "bots"
      self.prefix = "/management/v2.6/projects/:project_id/"

      # Parameter for create
      # {
      #   "botId": "botid",
      #   "scenarioProjectId", "DSU",
      #   "language": "ja-JP",
      #   "description": "hello"
      # }
    end
  end
end
