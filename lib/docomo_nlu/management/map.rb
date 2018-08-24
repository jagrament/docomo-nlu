module DocomoNlu
  module Management
    class Map < Base
      self.element_name = "maps"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      # Override
      def upload(file_path)
        path = "management/#{DocomoNlu.config.nlu_version}/projects/#{prefix_options[:project_id]}/bots/#{prefix_options[:bot_id]}/#{self.class.element_name}"

        conn = Faraday.new(url: self.class.site.to_s, ssl: { verify: false }) do |builder|
          builder.request :multipart # マルチパートでデータを送信
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
          builder.response :logger if %w[staging development].include?(Rails.env)
        end

        conn.headers["Authorization"] = self.class.access_token

        params = {
          uploadFile: Faraday::UploadIO.new(file_path, "text/plain"),
        }
        conn.put path, params
      end
    end
  end
end
