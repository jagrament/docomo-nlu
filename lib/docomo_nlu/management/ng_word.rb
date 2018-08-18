module DocomoNlu
  module Management
    class NGWord < Base
      self.element_name = "ngWords"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
