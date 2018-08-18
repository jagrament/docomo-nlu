module DocomoNlu
  module Management
    class DefaultPredicate < Base
      self.element_name = "defaultPredicates"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"
    end
  end
end
