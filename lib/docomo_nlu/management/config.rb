module DocomoNlu
  module Management
    class Config < Base
      self.element_name = "configs"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      # {
      #   "dialogTimeout": 300,
      #   "replyTimeout": 300,
      #   "xxxxUrl": "http://xxx",  (サービスURL)
      #   "yyyyUrl": "http://xxx",  (サービスURL)
      #   "sensitiveInfo": "aa.bb, ccc.ddd...",
      #   "sraix" : [true|false],
      #   "taskServerUrl": "http://xxx"
      # }
      def save
        path = "/management/#{DocomoNlu.config.nlu_version}/projects/#{prefix_options[:project_id]}/bots/#{prefix_options[:bot_id]}/configs"
        @attributes.delete(:id)
        response = connection.put(path, @attributes.to_json, self.class.headers)
        response
      end
    end
  end
end
