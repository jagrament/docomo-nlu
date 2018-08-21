module DocomoNlu
  module Management
    class OrganizationMember < Base
      self.element_name = 'members'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/organizations/:organization_id/"

      def destroy
        self.id = self.accountId
        super
      end

      class Format
        def extension
          'json'
       end

        def mime_type
          'application/json'
       end

        def encode(hash, options = nil)
          ActiveSupport::JSON.encode(hash, options)
        end

        def decode(json)
          if json.present?
            data = ActiveSupport::JSON.decode(json).values.first
          end
        end
      end

      self.format = Format.new
    end
  end
end
