# frozen_string_literal: true

module DocomoNlu
  module Management::V23
    class ProjectMember < Base
      self.element_name = "members"
      self.prefix = "/management/v2.2/projects/:project_id/"

      def destroy
        self.id = accountId
        super
      end
    end
  end
end
