# frozen_string_literal: true

module DocomoNlu
  module Management
    class Project < Base
      self.element_name = 'projects'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #   "projectName": "プロジェクト名" # not null
      #   "organizationId":組織ID # not null
      # }
    end
  end
end
