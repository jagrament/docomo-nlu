module DocomoNlu
  module Management
    class Organization < Base
      self.element_name = "organizations"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"

      # Parameter create
      # {
      #    "organizationName": "組織名", # not null
      #    "address": "住所",
      #    "tel": "電話番号"
      # }

      def to_json(options={})
        self.attributes.delete('organizationId')
        self.attributes.delete('id')
        super
      end
    end
  end
end
