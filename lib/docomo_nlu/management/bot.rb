module DocomoNlu
  module Management
    class Bot < Base
      self.element_name = "bots"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/"

      # Parameter for create
      # {
      #   "botId": "botid", # not null
      #   "scenarioProjectId", "DSU", # not null
      #   "language": "ja-JP", # not null
      #   "description": "hello" # not null
      # }

      self.format = DocomoNlu::Formats::JsonFormat.new

    end
  end
end
