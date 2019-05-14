# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Entry < Base
      self.element_name = ""
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/:method"

      def initialize(attributes = {}, persisted = false)
        super(attributes, persisted)
        prefix_options[:method] = "entry"
      end

      def save
        self.class.upload(attributes[:file], prefix_options)
      end

      def status
        self.class.check_status(prefix_options)
      end

      class << self
        def check_status(prefix_options)
          JSON.parse(connection.get("#{collection_path(prefix_options)}/status", headers).body)
        end

        def upload(file, prefix_options)
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.request :multipart # マルチパートでデータを送信
            builder.request :url_encoded
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = access_token
          params = {
            uploadFile: Faraday::UploadIO.new(file.path, "text/plain"),
          }
          response = conn.post collection_path(prefix_options), params
          check_response(response)
        end
      end
    end
  end
end
