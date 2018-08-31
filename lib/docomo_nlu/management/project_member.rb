# frozen_string_literal: true

module DocomoNlu
  module Management
    class ProjectMember < Base
      self.element_name = 'members'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/"

      def destroy
        self.id = accountId
        super
      end
    end
  end
end
