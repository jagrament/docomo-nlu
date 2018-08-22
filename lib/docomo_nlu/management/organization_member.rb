module DocomoNlu
  module Management
    class OrganizationMember < Base
      self.element_name = 'members'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/organizations/:organization_id/"

      def destroy
        self.id = self.accountId
        super
      end

      self.format = DocomoNlu::Formats::JsonFormat.new

    end
  end
end
