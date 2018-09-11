# frozen_string_literal: true

module DocomoNlu
  module Management
    class Organization < Base
      self.element_name = "organizations"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

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
