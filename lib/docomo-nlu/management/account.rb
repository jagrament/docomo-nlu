# frozen_string_literal: true

module DocomoNlu
  module Management
    class Account < Base
      self.element_name = "accounts"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #     "accountName": "your account name",
      #     "password": "your account password",
      #     "description": "account description",
      #     "authorization": 2,
      #     "enable": true
      # }

      def self.count
        response_body = JSON.parse(connection.get("#{prefix}#{element_name}/count", headers).body)
        response_body["count"]
      end

      def to_json(options = {})
        attributes.delete("accountId")
        attributes.delete("createDate")
        attributes.delete("loginDate")
        attributes.delete("id")
        super
      end
    end
  end
end
