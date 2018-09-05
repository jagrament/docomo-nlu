# frozen_string_literal: true

module DocomoNlu
  module Management
    class Bot < AIMLBase
      self.element_name = 'bots'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/"

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
