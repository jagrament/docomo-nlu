# frozen_string_literal: true

module DocomoNlu
  module Management::V23
    class TaskProject < Base
      self.element_name = "taskProjects"
      self.prefix = "/management/v2.2/"

      # Parameter for create
      # {
      #   "scenarioProjectId": "",
      #   "description": "",
      #   "publicHost": "",
      #   "internalHosts": [
      #        "nnn.nnn.nnn.nnn", "nnn.nnn.nnn.nnn", "nnn.nnn.nnn.nnn"
      #    ]
      # }
    end
  end
end
