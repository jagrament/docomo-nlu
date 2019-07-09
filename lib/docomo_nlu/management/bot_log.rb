# frozen_string_literal: true

require "zip"

module DocomoNlu
  module Management
    class BotLog < Base
      self.element_name = "botlogs"
      self.prefix = "/management/v2.6/projects/:project_id/"

      def all
        Rails.logger.debug "You shoud use 'download' method"
      end

      def find
        Rails.logger.debug "You shoud use 'download' method"
      end

      def where
        Rails.logger.debug "You shoud use 'download' method"
      end

      def download(bot_id, params = {})
        attributes[:file] = self.class.download(prefix_options, bot_id, params.slice(:start, :end))
        attributes[:file]
      end

      def extract_data
        return unless attributes[:file]

        logs = []
        self.class.unzip(attributes[:file]) do |_name, body|
          logs = body.map {|b| JSON.parse(b) }
        end
        logs
      end

      class << self
        def download(prefix_options, bot_id, params = {})
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = access_token
          response = conn.get("#{collection_path(prefix_options)}?botId=#{bot_id}&#{params.to_query}")

          if check_response(response)
            return Tempfile.open(["docomo-nlu", ".zip"]) do |f|
              f.binmode
              f.write response.body
              f
            end
          end
          nil
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
