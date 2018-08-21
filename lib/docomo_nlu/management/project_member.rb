module DocomoNlu
  module Management
    class ProjectMember < Base
      self.element_name = "members"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/"

      def destroy
        self.id = self.accountId
        super
      end

      class Format
        def extension
          "json"
       end

        def mime_type
          "application/json"
       end

        def encode(hash, options = nil)
          ActiveSupport::JSON.encode(hash, options)
        end

        # For support NLPManagement API response
        #   Response Body
        #   {
        #   "accoundIds":[{
        #     "accountId": アカウントID
        #     },{
        #     "accountId": アカウントID
        #     }…
        #     ]
        #   }
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
