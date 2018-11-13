# frozen_string_literal: true

module DocomoNlu
  module Management::V23
    class Provider < Base
      self.element_name = "providers"
      self.prefix = "/management/v2.2/"

      # Parameter for create
      # {
      #   "organizationId": "id",
      #   "serverKind":"SS",
      #   "serverId":  "DSU"
      # }
    end
  end
end
