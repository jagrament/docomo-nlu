# frozen_string_literal: true

module DocomoNlu
  class Spontaneous < ActiveResource::Base
    attr_accessor :result
    attr_accessor :error
    self.site = DocomoNlu.config.nlu_host

    ## Remove format in path (remove .json)
    self.include_format_in_path = false

    ## Setting Format
    self.format = :json

    def initialize
      super
      {
        clientVer:    "1.0.4",
        language:     "ja-JP",
        location:     { lat: "0", lon: "0" },
        appRecvTime:  DateTime.now.strftime("%Y-%m-%d %H:%M:%S"),
        appSendTime:  DateTime.now.strftime("%Y-%m-%d %H:%M:%S"),
      }.each do |k,v|
        @attributes.store(k,v)
      end
    end

    def registration(app_kind="docomo-nlu", app_id="", registration_id="",notification=false)
      body = {
        bot_id: @attributes[:botId],
        app_id: app_id,
        registration_id: registration_id,
        app_kind: app_kind,
        notification: notification
      }
      res = connection.post("/UserRegistrationServer/users/applications", body.to_json, self.class.headers)
      @attributes.store(:appId, JSON.parse(res.body)["app_id"])
    end

    def dialogue(voiceText, **params)
      @attributes[:voiceText] = voiceText
      params.each do |k,v|
        @attributes[k] ||= v
      end
      res = connection.post("/SpontaneousDialogueServer/dialogue", @attributes.to_json, self.class.headers)
      @result = JSON.parse(res.body)
    end
  end
end
