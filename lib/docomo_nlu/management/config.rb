module DocomoNlu
  module Management
    class Config < Base
      self.element_name = "configs"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      # {
      #   "dialogTimeout": 300,
      #   "replyTimeout": 300,
      #   "xxxxUrl": "http://xxx",  (service URL)
      #   "yyyyUrl": "http://xxx",  (service URL)
      #   "sensitiveInfo": "aa.bb, ccc.ddd...",
      #   "sraix" : [true|false],
      #   "taskServerUrl": "http://xxx"
      # }

      def destroy(keys)
        self.id = keys.join(',')
        super()
      end
    end
  end
end
