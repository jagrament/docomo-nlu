# frozen_string_literal: true

module DocomoNlu
  module Management
    class ScenarioProject < Base
      self.element_name = "scenarioProjects"
      self.prefix = "/management/#{DocomoNlu.config.nlu_version}/"
    end
  end
end
