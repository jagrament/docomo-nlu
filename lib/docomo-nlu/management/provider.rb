# frozen_string_literal: true

module DocomoNlu
  module Management
    class Provider < Base
      self.element_name = 'providers'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #   "organizationId": "id",
      #   "serverKind":"SS",
      #   "serverId":  "DSU"
      # }
    end
  end
end
