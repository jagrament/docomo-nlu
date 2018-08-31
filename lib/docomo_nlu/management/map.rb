module DocomoNlu
  module Management
    class Map < MultipartBase
      self.element_name = "maps"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
