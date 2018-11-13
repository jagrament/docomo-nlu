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

# require 'rubyzip'

require "tempfile"
module DocomoNlu
  module Management::V26
    class AIMLBase < Base
      ## For AIML

      def download(extra_path = "")
        prefix_options[:bot_id] ||= botId
        @attributes[:file] = self.class.download(prefix_options, extra_path).file
      end

      def upload(file, type = :aiml)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] ||= type
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

      ## For FAQ

      def upload_userdic(file)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "userDic"
        self.class.upload(file, prefix_options)
      end

      def upload_stopkey(file)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "stopkey"
        self.class.upload(file, prefix_options)
      end

      def download_stopkey
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "stopkey"
        @attributes[:stopkey] = self.class.download(prefix_options).file
      end

      def upload_truthlist(file)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "truthlist"
        self.class.upload(file, prefix_options)
      end

      def download_truthlist
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "truthlist"
        @attributes[:truthlist] = self.class.download(prefix_options).file
      end

      def upload_entry(file)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = "entry"
        self.class.upload(file, prefix_options)
      end

      def check_faq_status(method)
        prefix_options[:bot_id] ||= botId
        prefix_options[:method] = method
        self.class.check_status(:faq, "#{FileModel.collection_path(prefix_options)}/status")
      end

      class << self
        def download(prefix_options, extra_path = "")
          conn = Faraday.new(url: site.to_s, ssl: { verify: false }) do |builder|
            builder.adapter :net_http
          end
          conn.headers["Authorization"] = access_token
          response = conn.get("#{FileModel.collection_path(prefix_options)}/#{extra_path}")

          if check_response(response)
            instantiate_record({}, prefix_options).tap do |record|
              record.file = Tempfile.open(["docomo-nlu", ".#{prefix_options[:method]}"]) do |f|
                f.write response.body.force_encoding("UTF-8")
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
          conn.headers["Authorization"] = access_token
          params = {
            uploadFile: Faraday::UploadIO.new(file.path, "text/plain"),
          }
          response = conn.put FileModel.collection_path(prefix_options), params
          check_response(response)
        end

        def compile(prefix_options)
          return if deploy_request(:compile, prefix_options)  != ""
        end

        def transfer(prefix_options)
          return if deploy_request(:transfer, prefix_options) != ""
        end

        def deploy_request(method, prefix_options)
          response_body = JSON.parse(connection.post(Scenario.element_path(method, prefix_options), "", headers).body)
          # Sometimes, API returns wrong url, replace correct path.
          URI.parse(response_body["statusUri"]).path.gsub!(/NLPManagementAPI/, "management/v2.6")
        end

        def deploy(prefix_options)
          # compile and status check
          compile_status = false
          check_path = deploy_request(:compile, prefix_options)
          while check_path && compile_status != "Completed"
            sleep(0.2)
            compile_status = check_status(:compile, check_path)
            raise ActiveResource::ServerError if %w[ErrorFinish NotCompiled].include?(compile_status)
          end

          # transfer and status check
          transfer_status = false
          check_path = deploy_request(:transfer, prefix_options)
          while check_path && transfer_status != "Completed"
            sleep(0.2)
            transfer_status = check_status(:transfer, check_path)
            raise ActiveResource::ServerError if %w[ErrorFinish NotTransfered].include?(transfer_status)
          end
          true
        end

        def check_status(method, path)
          case method
          when :compile, :faq then JSON.parse(connection.get(path, headers).body)["status"]
          when :transfer      then JSON.parse(connection.get(path, headers).body)["transferStatusResponses"][0]["status"]
          end
        end

        # def generate_file(response, method)
        #   case method
        #   when :aiml, :dat then
        #     Tempfile.open(["docomo-nlu", ".#{prefix_options[:method].to_s}"]) do |f|
        #       f.write response.body.force_encoding("UTF-8")
        #       f
        #     end
        #   when :zip then
        #     zip_file = Tempfile.new(["docomo-nlu", ".#{prefix_options[:method].to_s.gsub(/archive/, "zip")}"])
        #     Zip::OutputStream.open(zip_file.path) do |zip|
        #       @targets.each do |target|
        #         zip.put_next_entry("#{target.filename}.pdf")
        #         zip.print Net::HTTP.get URI.parse(target.url)
        #       end
        #     end
        #     Zip::File.open_buffer(file.read) do |zf|
        #       zf.each do |entry|
        #         p entry.name # ファイル名
        #         p entry.get_input_stream.read # ファイルの中身
        #       end
        #     end
        #   end
        # end
      end

      class FileModel < Base
        self.element_name = ""
        self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/:method"
      end
    end
  end
end
