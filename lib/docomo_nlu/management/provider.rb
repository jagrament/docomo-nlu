# frozen_string_literal: true

module DocomoNlu
  module Management
    class Provider < Base
      self.element_name = 'providers'
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter for create
      # {
      #   "organizationId": 組織ID, # not null
      #   "serverKind":"SS", # static not null
      #   "serverId":  "DSU" # static not null
      # }
    end
  end
end
