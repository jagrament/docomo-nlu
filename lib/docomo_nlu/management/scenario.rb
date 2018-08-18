module DocomoNlu
  module Management
    class Scenario < Base
      self.element_name = "scenarios"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      class Format
        def extension
          "json"
        end

        def mime_type
          "application/json"
        end

        def encode(hash, options = nil)
          ActiveSupport::JSON.encode(hash, options)
        end

        # For support NLPManagement API response
        #   Response Body
        # {
        #   "userScenarios": [{
        #     "scenarioId": "d2f2fba2c19941abae91a9733e84f927_sebastien",
        #     "description": "",
        #     "compileFlag": true,
        #     "compilable": true,
        #     "authoring": false,
        #     "lastmodified": "2016-12-02 09:52:43"
        #   }]
        # }
        def decode(json)
          if json.present?
            data = ActiveSupport::JSON.decode(json).values[1]
          end
        end
      end

      self.format = Format.new

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
          builder.adapter  Faraday.default_adapter
          builder.response :logger if %w[staging development].include?(Rails.env)
        end

        conn.headers["Authorization"] = self.class.access_token

        params = {
          uploadFile: Faraday::UploadIO.new(file_path, "text/plain"),
        }
        conn.put path, params
      end

      def deploy
        # コンパイル実行、ポーリングチェック
        compile_status_path = compile
        compile_status = false
        while compile_status_path && compile_status != "Completed"
          sleep(0.5)
          compile_status = check_compile_status(compile_status_path)
          raise if compile_status == "ErrorFinish" || compile_status == "NotCompiled"
        end

        # 転送実行、ポーリングチェック
        transfer_status_path = transfer
        transfer_status = false

        while transfer_status_path && transfer_status != "Completed"
          sleep(0.5)
          transfer_status = check_transfer_status(transfer_status_path)
          raise if transfer_status == "ErrorFinish" || transfer_status == "NotTransfered"
        end
      end

      def compile
        deploy_request(:compile)
      end

      def transfer
        deploy_request(:transfer)
      end

      def deploy_request(method)
        response_body = JSON.parse(connection.post(get_deploy_path(method), "", self.class.headers).body)
        ## 対話サーバが返してくるステータスチェック用のエンドポイントが誤っているので、
        ## パッチとして正しいエンドポイントに置換している。
        ## TODO 対話サーバのバグ改修に合わせて、gsubを削除する

        URI.parse(response_body["statusUri"]).path.gsub!(/NLPManagementAPI/, "management/#{DocomoNlu.config.nlu_version}")
      end

      def check_compile_status(path)
        JSON.parse(connection.get(path, self.class.headers).body)["status"]
      end

      def check_transfer_status(path)
        # TODO: 複数の対話サーバに転送する事が可能なため、ホストごとの状態が配列で帰ってくるが
        # 現時点では一つのホストの状態をチェックするだけの実装
        JSON.parse(connection.get(path, self.class.headers).body)["transferStatusResponses"][0]["status"]
      end

      def get_deploy_path(method)
        "/management/#{DocomoNlu.config.nlu_version}/projects/#{prefix_options[:project_id]}/bots/#{prefix_options[:bot_id]}/scenarios/#{method}"
      end
    end
  end
end
