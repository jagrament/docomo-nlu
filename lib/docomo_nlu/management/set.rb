module DocomoNlu
  module Management
    class Set < MultipartBase
      self.element_name = "sets"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
