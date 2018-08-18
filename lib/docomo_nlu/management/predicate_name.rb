module DocomoNlu
  module Management
    class PredicateName < Base
      self.element_name = "predicateNames"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
