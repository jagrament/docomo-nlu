# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class OrganizationMember < Base
      self.element_name = "members"
      self.prefix = "/management/v2.6/organizations/:organization_id/"

      def destroy
        self.id = accountId
        super
      end
    end
  end
end
