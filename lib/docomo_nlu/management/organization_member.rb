module DocomoNlu
  module Management
    class OrganizationMember < Base
      self.element_name = 'members'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/organizations/:organization_id/"

      # Parameter on create
      # {
      #   "accountIds": [{accountId: アカウントID},...] # not null
      # }

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

        # For support NLPManagement API response
        #   Response Body
        #   {
        #   "members":[
        #      アカウントID,
        #      …
        #     ]
        #   }
        def decode(json)
          if json.present?
            data = ActiveSupport::JSON.decode(json).values.first
            # if data.is_a?(Array) && data.length == 1 && data[0].is_a?(Enumerable)
            #   data = {accountId: data[0]}
            # else
            #   # [{"accountId": xxx},{"accountId": xxx}]に整形
            #   data.map!{|accountId| {accountId: accountId}}
            # end
          end
        end
      end

      self.format = Format.new
    end
  end
end
