module DocomoNlu
  module Management
    class DefaultPredicate < Base
      self.element_name = "defaultPredicates"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      def destroy(keys)
        self.id = keys.join(',')
        super()
      end
    end
  end
end
