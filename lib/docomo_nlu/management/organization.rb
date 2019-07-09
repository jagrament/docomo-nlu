# frozen_string_literal: true

module DocomoNlu
  module Management
    class Organization < Base
      self.element_name = "organizations"
      self.prefix = "/management/v2.6/"

      # Parameter create
      # {
      #    "organizationName": "your organization name",
      #    "address": "address",
      #    "tel": "tel"
      # }

      def to_json(options = {})
        attributes.delete("organizationId")
        attributes.delete("id")
        super
      end
    end
  end
end
