# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Project < Base
      self.element_name = "projects"
      self.prefix = "/management/v2.6/"

      # Parameter for create
      # {
      #   "projectName": "your project name"
      #   "organizationId": "your organization id"
      # }
    end
  end
end
