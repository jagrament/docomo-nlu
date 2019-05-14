# frozen_string_literal: true

require "net/http"

module DocomoNlu
  module Management::V26
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

      self.format = :json

      ## Get NLPManagement's AccessToken.
      def login(account_name, password)
        request_body = { account_name: account_name, password: password }.to_json
        response_body = JSON.parse(connection.post("/management/v2.6/login", request_body, self.class.headers).body)
        self.access_token = response_body["accessToken"]
      end

      ## Delete NLPManagement's AccessToken.
      def logout
        res = connection.get("/management/v2.6/logout", self.class.headers) if access_token.present?
        raise ActiveResource::BadRequest, "Invalid access token" unless res

        self.access_token = nil
        true
      end

      ## Override. Insert generated id to parameter 'id' after save or create
      def id_from_response(response)
        ActiveSupport::JSON.decode(response.body)["#{self.class.to_s.split("::").last.downcase!}Id"] if response.body.present?
      end

      class << self
        def instantiate_collection(collection, original_params = {}, prefix_options = {})
          if collection.is_a?(Hash)
            collection = if collection.empty? || collection.first[1].nil?
                           []
                         else
                           [collection]
                         end
          elsif collection[0].is_a?(String)
            collection = [{ params: collection }]
          end
          super
        end

        def instantiate_record(record, prefix_options = {})
          record = record[0] if record.is_a?(Array)
          resource_id = record["#{to_s.split("::").last.downcase!}Id"]
          record["id"] = resource_id if resource_id
          super
        end

        def headers
          new_headers = static_headers.clone
          new_headers["Authorization"] = access_token
          new_headers
        end

        def check_response(response)
          case response.status
          when 400       then raise ActiveResource::BadRequest, response
          when 401       then raise ActiveResource::UnauthorizedAccess, response
          when 403       then raise ActiveResource::ForbiddenAccess, response
          when 404       then raise ActiveResource::ResourceNotFound, response
          when 409       then raise ActiveResource::ResourceConflict, response
          when 503       then raise ActiveResource::ServerError, response
          when 200..204  then true
          end
        end
      end
    end
  end
end
