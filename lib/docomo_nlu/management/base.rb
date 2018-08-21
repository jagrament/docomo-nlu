module DocomoNlu
  module Management
    class Base < ActiveResource::Base
      ## For Dynamically generated headers via http://rmosolgo.github.io/blog/2014/02/05/dynamically-generated-headers-for-activeresource-requests/
      cattr_accessor :static_headers
      cattr_accessor :access_token

      ## Dynamic headers
      self.static_headers = headers

      ## Admin Accesstoken
      self.access_token = DocomoNlu.config.admin_access_token

      ## Setting Endpoint.
      self.site = DocomoNlu.config.nlu_host

      ## Remove format in path (remove .json)
      self.include_format_in_path = false

      ## Setting Format
      self.format = :json

      ## Get NLPManagement's AccessToken.
      def login(accountName, password)
        request_body = { accountName: accountName, password: password }.to_json
        response_body = JSON.parse(connection.post("/management/#{DocomoNlu.config.nlu_version}/login", request_body, self.class.headers).body)
        self.access_token = response_body['accessToken']
      end

      ## Delete NLPManagement's AccessToken.
      def logout
        connection.get("/management/#{DocomoNlu.config.nlu_version}/logout", self.class.headers) if self.access_token.present?
        self.access_token = nil
      end

      ## Override. Insert generated id to parameter 'id' after save or create
      def id_from_response(response)
        ActiveSupport::JSON.decode(response.body)["#{self.class.to_s.split('::').last.downcase!}Id"] if response.body.present?
      end

      class << self
        ## Override. Insert generated id to parameter 'id' after find
        def instantiate_record(record, prefix_options = {})
          record = record[0] if record.is_a?(Array)
          record['id'] = record["#{self.to_s.split("::").last.downcase!}Id"]
          super
        end

        def headers
          new_headers = static_headers.clone
          new_headers['Authorization'] = self.access_token
          new_headers
        end
      end
    end
  end
end
