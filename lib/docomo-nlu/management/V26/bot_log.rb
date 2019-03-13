# frozen_string_literal: true
require "zip"

module DocomoNlu
  module Management::V26
    class BotLog < Base
      self.element_name = "botlogs"
      self.prefix = "/management/v2.6/projects/:project_id/"

      def all
        p "You shoud use 'download' method"
      end

      def find
        p "You shoud use 'download' method"
      end

      def where
        p "You shoud use 'download' method"
      end

      def download(bot_id, params = {})
        file = self.class.download(prefix_options, bot_id, params)
        self.class.unzip(file) do |name, body|
          attributes[:logs] = body.map do |b|
            JSON.parse(b)
          end
        end
        return file
      end

      class << self
        def download(prefix_options, bot_id, params = {})
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = access_token
          response = conn.get("#{collection_path(prefix_options)}?botId=#{bot_id}")

          if check_response(response)
            Tempfile.open(["docomo-nlu", ".zip"]) do |f|
              f.write response.body
              f
            end
          end
        end

        def unzip(file)
          ::Zip::File.open(file.path) do |zf|
            zf.each do |entry|
              next unless entry.file?
              name = entry.name
              body = entry.get_input_stream.read.split(/\R/)
              yield name, body if block_given?
            end
          end
        end
      end
    end
  end
end
