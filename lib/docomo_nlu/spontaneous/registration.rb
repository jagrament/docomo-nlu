require "securerandom"
module DocomoNlu
  module Spontaneous
    class Registration < ActiveResource::Base
      attr_accessor :result
      self.site = "http://#{DocomoNlu.config.nlu_host}/"

      ## Remove format in path (remove .json)
      self.include_format_in_path = false

      ## Setting Format
      self.format = :json

      # 対話サーバからのapp_Id払い出し処理
      # Parameter
      # {
      #  "app_id"           : "sebastien-marketplace",
      #  "bot_id"           : "botId",
      #  "registration_id"  : "null",
      #  "app_kind"         : "sebastien-marketplace",
      #  "notification"     : false
      # }
      def registration(app_id, bot_id, app_kind = "developer_dashboard")
        request_body =
          { "app_id" => app_id, "bot_id" => bot_id, "registration_id" => nil, "app_kind" => app_kind, "notification" => false }.to_json
        res = connection.post("/UserRegistrationServer/users/applications", request_body, self.class.headers)
        if res.code == "200"
          attributes.store("appId", app_id)
        else
          attributes.store("errors", res.body)
        end
      end

      def execute(voice_text, init_topic_d = nil)
        self.voiceText = voice_text
        self.initTopicId = init_topic_id unless init_topic_id.nil?
        res = connection.post("/SpontaneousDialogueServer/dialogue", self.attributes.to_json, self.class.headers)
        @result = res
      end

      class << self
        def collection_path(prefix_options = {}, query_options = nil)
          check_prefix_options(prefix_options)
          prefix_options, query_options = split_options(prefix_options) if query_options.nil?
          "#{prefix(prefix_options)}#{collection_name}#{format_extension}#{query_string(query_options)}"
        end
        # Override. Native code is here
        # @collection_name ||= ActiveSupport::Inflector.pluralize(element_name)

        def collection_name
          @collection_name ||= element_name
        end
      end
    end
  end
end
