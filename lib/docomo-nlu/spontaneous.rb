# frozen_string_literal: true

module DocomoNlu
  class Spontaneous < ActiveResource::Base
    cattr_accessor :static_headers
    self.site = DocomoNlu.config.nlu_host

    ## Remove format in path (remove .json)
    self.include_format_in_path = false

    ## Setting Format
    self.format = :json

    self.static_headers = headers

    def initialize
      super
      {
        clientVer:    "1.0.4",
        language:     "ja-JP",
        location:     { lat: "0", lon: "0" },
        appRecvTime:  DateTime.now.strftime("%Y-%m-%d %H:%M:%S"),
        appSendTime:  DateTime.now.strftime("%Y-%m-%d %H:%M:%S"),
      }.each do |k, v|
        @attributes.store(k, v)
      end
    end

    def registration(app_id = "", registration_id = "docomo-nlu", app_kind = "docomo-nlu", notification = false)
      body = {
        bot_id: @attributes[:botId],
        app_id: app_id,
        registration_id: registration_id,
        app_kind: app_kind,
        notification: notification,
      }
      res = connection.post("/UserRegistrationServer/users/applications", body.to_json, self.class.headers)
      @attributes.store(:appId, JSON.parse(res.body)["app_id"])
    end

    def dialogue(voiceText, **params)
      @attributes[:voiceText] = voiceText
      params.each do |k, v|
        @attributes[k] ||= v
      end
      res = connection.post("/SpontaneousDialogueServer/dialogue", @attributes.to_json, self.class.headers)
      return JSON.parse(res.body)
    end

    class << self
      def headers
        new_headers = static_headers.clone
        new_headers["Content-Type"] = "application/json;charset=UTF-8"
        new_headers
      end
    end
  end
end
