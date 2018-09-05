# frozen_string_literal: true

# download([:aiml,:dat,:archive],scenarioId)
# GET /{projectId}/bots/{botId}/aiml/{scenarioId}
# GET /{projectId}/bots/{botId}/dat
# GET /{projectId}/bots/{botId}/archive

# upload([:aiml,:dat,:archive],filepath)
# /{projectId}/bots/{botId}/aiml
# /{projectId}/bots/{botId}/dat
# /{projectId}/bots/{botId}/archive

# Not supported
# GET /{projectId}/bots/{botId}/archive/aiml

require 'tempfile'
module DocomoNlu
  module Management
    class AIMLBase < Base
      def download(extra_path = '')
        prefix_options[:bot_id] ||= botId
        @attributes[:file] = self.class.download(prefix_options, extra_path).file
      end

      def upload(file)
        prefix_options[:bot_id] ||= botId
        self.class.upload(file, prefix_options)
      end

      def compile
        prefix_options[:bot_id] ||= botId
        self.class.compile(prefix_options)
      end

      def transfer
        prefix_options[:bot_id] ||= botId
        self.class.deploy_request(prefix_options)
      end

      def deploy
        prefix_options[:bot_id] ||= botId
        self.class.deploy(prefix_options)
      end

      class << self
        def download(prefix_options, extra_path = '')
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers['Authorization'] = access_token
          response = conn.get("#{FileModel.collection_path(prefix_options)}/#{extra_path}")

          if check_response(response)
            instantiate_record({}, prefix_options).tap do |record|
              record.file = Tempfile.open(['docomo-nlu', ".#{prefix_options[:method].to_s.gsub(/archive/, 'zip')}"]) do |f|
                f.write response.body
                f
              end
            end
          end
        end

        def upload(file, prefix_options)
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.request :multipart # マルチパートでデータを送信
            builder.request :url_encoded
            builder.adapter :net_http
          end
          conn.headers['Authorization'] = access_token
          params = {
            uploadFile: Faraday::UploadIO.new(file.path, 'text/plain')
          }
          response = conn.put FileModel.collection_path(prefix_options), params
          check_response(response)
        end

        def compile(prefix_options)
          return if deploy_request(:compile, prefix_options)  != ''
        end

        def transfer(prefix_options)
          return if deploy_request(:transfer, prefix_options) != ''
        end

        def deploy_request(method, prefix_options)
          response_body = JSON.parse(connection.post(Scenario.element_path(method, prefix_options), '', headers).body)
          # Sometimes, API returns wrong url, replace correct path.
          URI.parse(response_body['statusUri']).path.gsub!(/NLPManagementAPI/, "management/#{DocomoNlu.config.nlu_version}")
        end

        def deploy(prefix_options)
          # compile and status check
          compile_status = false
          check_path = deploy_request(:compile, prefix_options)
          while check_path && compile_status != 'Completed'
            sleep(0.2)
            compile_status = check_status(:compile, check_path)
            raise ActiveResource::ServerError if %w[ErrorFinish NotCompiled].include?(compile_status)
          end

          # transfer and status check
          transfer_status = false
          check_path = deploy_request(:transfer, prefix_options)
          while check_path && transfer_status != 'Completed'
            sleep(0.2)
            transfer_status = check_status(:transfer, check_path)
            raise ActiveResource::ServerError if %w[ErrorFinish NotTransfered].include?(transfer_status)
          end
          true
        end

        def check_status(method, path)
          case method
          when :compile   then JSON.parse(connection.get(path, headers).body)['status']
          when :transfer  then JSON.parse(connection.get(path, headers).body)['transferStatusResponses'][0]['status']
          end
        end
      end

      class FileModel < Base
        self.element_name = ''
        self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/:method"
      end
    end
  end
end
