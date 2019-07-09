# frozen_string_literal: true

module DocomoNlu
  module Management
    class TaskProject < Base
      self.element_name = "taskProjects"
      self.prefix = "/management/v2.6/"

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
