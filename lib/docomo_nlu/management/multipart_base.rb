require 'tempfile'
module DocomoNlu
  module Management
    class MultipartBase < Base
      def save
        self.class.create(self.attributes[:file], self.prefix_options)
      end

      def destroy
        self.id = self.try(:category)
        super
      end

      class << self

        def create(file, prefix_options)
          check_prefix_options(prefix_options)
          raise ActiveResource::BadRequest.new('') if !file.instance_of?(File)

          upload(file,prefix_options)
        end

        def find(*arguments)
          scope   = arguments.slice!(0)
          options = arguments.slice!(0) || {}

          prefix_options, query_options = split_options(options[:params])
          check_prefix_options(prefix_options)

          case scope
            when :all   then download(nil,   prefix_options)
            else             download(scope, prefix_options)
          end
        end

        def where(clauses = {})
          raise ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash
          category = clauses[:category]
          find(category, :params => clauses)
        end

        private
        def download(category = nil, prefix_options)
          extention = category.blank? ? '.zip' : '.map'

          conn = Faraday.new(url: self.site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = self.access_token

          response = conn.get(element_path(category, prefix_options))

          instantiate_record({},prefix_options).tap{|record|
              record.file = Tempfile.open(['docomo_nlu', extention]) do |f|
                f.write response.body
                f
              end
              record.category = category
            } if check_response(response)
        end

        def upload(file, prefix_options)
          conn = Faraday.new(url: self.site.to_s, ssl: { verify: false }) do |builder|
            builder.request :multipart # マルチパートでデータを送信
            builder.request :url_encoded
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = self.access_token
          params = {
            uploadFile: Faraday::UploadIO.new(file.path, "text/plain"),
          }
          response = conn.put collection_path(prefix_options), params
          check_response(response)
        end

        def check_response(response)
          case response.status
            when 400       then raise ActiveResource::BadRequest.new(response)
            when 401       then raise ActiveResource::UnauthorizedAccess.new(response)
            when 403       then raise ActiveResource::ForbiddenAccess.new(response)
            when 404       then raise ActiveResource::ResourceNotFound.new(response)
            when 409       then raise ActiveResource::ResourceConflict.new(response)
            when 503       then raise ActiveResource::ServerError.new(response)
            when 200..204  then return true
          end
        end
      end
    end
  end
end
