# frozen_string_literal: true

module DocomoNlu
  module Management::V23
    class PredicateName < Base
      self.element_name = "predicateNames"
      self.prefix = "/management/v2.2/projects/:project_id/bots/:bot_id/"

      def destroy(keys)
        self.id = keys.join(",")
        super()
      end
    end
  end
end
