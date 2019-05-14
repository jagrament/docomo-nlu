# frozen_string_literal: true

module DocomoNlu
  module Management::V26
    class Scenario < AIMLBase
      self.element_name = "scenarios"
      self.prefix = "/management/v2.6/projects/:project_id/bots/:bot_id/"

      @permitted_root_param = [:userScenarios, :templateScenarios]
      @permitted_user_scenarios_param = [:scenarioId, :description, :compileFlag]

      def save
        @attributes.select! {|a| a =~ /(userScenarios|templateScenarios)/ }
        userScenarios.each do |us|
          us.attributes.select! {|a| a =~ /(scenarioId|description|compileFlag)/ }
        end
        super
      end

      def destroy(scenario_id)
        self.id = scenario_id
        super()
      end

      class UserScenarios < Base; end
      class TemplateScenarios < Base; end
    end
  end
end
