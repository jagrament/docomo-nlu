# frozen_string_literal: true

module DocomoNlu
  module Management
    class Scenario < AIMLBase
      self.element_name = "scenarios"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/projects/:project_id/bots/:bot_id/"

      def destroy(scenario_id)
        self.id = scenario_id
        super()
      end

      class UserScenarios < Base; end
      class TemplateScenarios < Base; end
    end
  end
end
