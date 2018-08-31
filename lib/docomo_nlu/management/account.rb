# frozen_string_literal: true

module DocomoNlu
  module Management
    class Account < Base
      self.element_name = 'accounts'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #     "accountName": "アカウント名", # not null
      #     "password": "パスワード", # not null
      #     "description": "表示名",
      #     "authorization": 2, # not null, static
      #     "enable": true # not null, static
      # }

      def self.count
        response_body = JSON.parse(connection.get("#{prefix}#{element_name}/count", headers).body)
        response_body['count']
      end

      def to_json(options = {})
        attributes.delete('accountId')
        attributes.delete('createDate')
        attributes.delete('loginDate')
        attributes.delete('id')
        super
      end
    end
  end
end
