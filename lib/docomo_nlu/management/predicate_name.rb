# frozen_string_literal: true

module DocomoNlu
  module Management
    class PredicateName < Base
      self.element_name = 'predicateNames'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      def destroy(keys)
        self.id = keys.join(',')
        super()
      end
    end
  end
end
