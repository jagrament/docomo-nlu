module DocomoNlu
  module Management
    class Account < Base
      self.element_name = "accounts"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version.to_s}/"

      # Parameter for create
      # {
      #     "accountName": "アカウント名", # not null
      #     "password": "パスワード", # not null
      #     "description": "表示名",
      #     "authorization": 2, # not null, static
      #     "enable": true # not null, static
      # }
    end
  end
end
