# frozen_string_literal: true

module DocomoNlu
  module Management
    class Scenario < Base
      self.element_name = 'scenarios'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      def destroy
        self.id = userScenarios.map(&:scenarioId).join(',')
        super
      end

      class UserScenarios < Base; end
      class UserScenarios < Base; end

      # Parameter for create
      # {
      #   "userScenario"：[
      #   {
      #     "scenarioId": "WEATHER",
      #     "description":"天気に関するトピック",
      #     "compileFlag": false,
      #    },
      #    …
      #   ]
      # }

      # scneaio.upload([:aiml,:dat,:archive],filepath)
      # /{projectId}/{botId}/aiml
      # /{projectId}/{botId}/dat
      # /{projectId}/{botId}/archive

      # scneaio.download([:aiml,:dat,:archive],scenarioId)
      # GET /{projectId}/{botId}/aiml/{scenarioId}
      # GET /{projectId}/{botId}/dat
      # GET /{projectId}/{botId}/archive

      # Not supported
      # GET /{projectId}/{botId}/archive/aiml

      # scneaio.deploy

      # scenario.destroy_file(scenarioId)
      # DELETE /{projectId}/{botId}/aiml/{scenarioId}

      # scenario.destroy
      # /{projectId}/{botId}/scenarios/{scenarioId1[,scenarioId2, ...]}

      def upload(method, file_path)
        path = "management/#{DocomoNlu.config.nlu_version}/projects/#{prefix_options[:project_id]}/bots/#{prefix_options[:bot_id]}/#{method}"

        conn = Faraday.new(url: self.class.site.to_s, ssl: { verify: false }) do |builder|
          builder.request :multipart # マルチパートでデータを送信
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
        end

        conn.headers['Authorization'] = self.class.access_token

        params = {
          uploadFile: Faraday::UploadIO.new(file_path, 'text/plain')
        }
        conn.put path, params
      end

      def deploy
        # compile and status check
        compile_status_path = compile
        compile_status = false
        while compile_status_path && compile_status != 'Completed'
          sleep(0.5)
          compile_status = check_compile_status(compile_status_path)
          raise ActiveResource::ServerError if %w[ErrorFinish NotCompiled].include?(compile_status)
        end

        # transfer and status check
        transfer_status_path = transfer
        transfer_status = false

        while transfer_status_path && transfer_status != 'Completed'
          sleep(0.5)
          transfer_status = check_transfer_status(transfer_status_path)
          raise ActiveResource::ServerError if %w[ErrorFinish NotTransfered].include?(transfer_status)
        end
        true
      end

      def compile
        deploy_request(:compile)
      end

      def transfer
        deploy_request(:transfer)
      end

      def deploy_request(method)
        response_body = JSON.parse(connection.post(get_deploy_path(method), '', self.class.headers).body)
        # API returns wrong url, replace correct path.
        URI.parse(response_body['statusUri']).path.gsub!(/NLPManagementAPI/, "management/#{DocomoNlu.config.nlu_version}")
      end

      def check_compile_status(path)
        JSON.parse(connection.get(path, self.class.headers).body)['status']
      end

      def check_transfer_status(path)
        # TODO: Currentry checking first host only. need to check multiple hosts status.
        JSON.parse(connection.get(path, self.class.headers).body)['transferStatusResponses'][0]['status']
      end

      def get_deploy_path(method)
        "/management/#{DocomoNlu.config.nlu_version}/projects/#{prefix_options[:project_id]}/bots/#{prefix_options[:bot_id]}/scenarios/#{method}"
      end
    end
  end
end
