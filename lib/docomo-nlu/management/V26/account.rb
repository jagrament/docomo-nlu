# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Account < Base
      self.element_name = "accounts"
      self.prefix = "/management/v2.6/"

      # Parameter for create
      # {
      #     "accountName": "your account name",
      #     "password": "your account password",
      #     "description": "account description",
      #     "authorization": 2,
      #     "enable": true
      #     "eternity": true
      # }

      def self.count
        response_body = JSON.parse(connection.get("#{prefix}#{element_name}/count", headers).body)
        response_body["count"]
      end

      def to_json(options = {})
        enable_params = ["accountName", "password", "description", "authorization", "enable", "eternity"]
        attributes.select! {|a| enable_params.include?(a) }
        super
      end
    end
  end
end
