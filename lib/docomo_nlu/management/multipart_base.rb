# frozen_string_literal: true

require "tempfile"
module DocomoNlu
  module Management
    class MultipartBase < Base
      def save
        self.class.create(attributes[:file], prefix_options)
      end

      def destroy
        self.id = try(:category)
        super
      end

      class << self
        def create(file, prefix_options)
          check_prefix_options(prefix_options)
          raise ActiveResource::BadRequest, "" unless file.instance_of?(File)

          upload(file, prefix_options)
        end

        def find(*arguments)
          scope   = arguments.slice!(0)
          options = arguments.slice!(0) || {}

          prefix_options, = split_options(options[:params])
          check_prefix_options(prefix_options)

          case scope
          when :all then download(nil, prefix_options)
          else download(scope, prefix_options)
          end
        end

        def where(clauses = {})
          raise ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash

          category = clauses[:category]
          find(category, params: clauses)
        end

        private

        def download(category = nil, prefix_options = {})
          extention = category.blank? ? ".zip" : ".map"

          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = access_token

          response = conn.get(element_path(category, prefix_options))

          if check_response(response)
            return instantiate_record({}, prefix_options).tap do |record|
              record.file = Tempfile.open(["docomo-nlu", extention]) do |f|
                f.write response.body.force_encoding("UTF-8")
                f
              end
              record.category = category
            end
          end
          nil
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
          response = conn.put collection_path(prefix_options), params
          check_response(response)
        end
      end
    end
  end
end
