# frozen_string_literal: true

module DocomoNlu
  module Management
    class ScenarioProject < Base
      self.element_name = 'scenarioProjects'
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
