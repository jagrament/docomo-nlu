module DocomoNlu
  module Management
    class TaskProject < Base
      self.element_name = "taskProjects"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #   "scenarioProjectId": "シナリオプロジェクトID",
      #   "description":"テスト用のプロジェクトです。",
      #   "publicHost":  "シナリオサーバホスト名",
      #   "internalHosts": [
      #        "nnn.nnn.nnn.nnn", "nnn.nnn.nnn.nnn", "nnn.nnn.nnn.nnn"
      #    ]
      # }
    end
  end
end
