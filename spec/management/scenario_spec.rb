RSpec.describe DocomoNlu::Management::Scenario do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#scenarios" do
    it "scenarios not found" do
      VCR.use_cassette("/scenario/index_not_found") do
        scenarios = DocomoNlu::Management::Scenario.all(params: { project_id: 212, bot_id: "test_bot" })
        expect(scenarios).to eq []
      end
    end

    it "Create a scenario" do
      VCR.use_cassette("/scenario/create") do
        scenario = DocomoNlu::Management::Scenario.new({ userScenarios: [{ scenarioId: "test_scenario", description: "test", compileFlag: true }] })
        scenario.prefix_options["project_id"] = 212
        scenario.prefix_options["bot_id"] = "test_bot"
        expect(scenario.save).to eq true
      end
    end

    it "Get all scenarios" do
      VCR.use_cassette("/scenario/index") do
        scenarios = DocomoNlu::Management::Scenario.all(params: { project_id: 212, bot_id: "test_bot" })
        expect(scenarios.first.userScenarios.first.scenarioId).not_to be_nil
      end
    end

    it "Conflict scenario Id" do
      VCR.use_cassette("/scenario/create_conflict") do
        scenario = DocomoNlu::Management::Scenario.new({ userScenarios: [{ scenarioId: "test_scenario", description: "test", compileFlag: true }] })
        scenario.prefix_options["project_id"] = 212
        scenario.prefix_options["bot_id"] = "test_bot"
        expect { scenario.save }.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it "Get a scenario" do
      VCR.use_cassette("/scenario/show") do
        scenario = DocomoNlu::Management::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        expect(scenario.userScenarios.first.scenarioId).to eq "test_scenario"
      end
    end

    it "Update a scenario (compileFlag)" do
      VCR.use_cassette("/scenario/show") do
        scenario = DocomoNlu::Management::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        VCR.use_cassette("/scenario/update") do
          scenario.compileFlag = true
          expect(scenario.save).to eq true
        end
      end
    end

    describe "#aiml" do
      it "Upload a scenario" do
        VCR.use_cassette("/scenario/upload") do
          scenario = DocomoNlu::Management::Scenario.new({ project_id: 212, bot_id: "test_bot" })
          response = scenario.upload(:aiml, stub_file("test.aiml"))
          expect(response.status).to eq 201
        end
      end

      it "Deploy scenario" do
        VCR.use_cassette("/scenario/deploy") do
          scenario = DocomoNlu::Management::Scenario.new({ project_id: 212, bot_id: "test_bot" })
          expect(scenario.deploy).to eq true
        end
      end
    end

    it "Delete a scenario" do
      VCR.use_cassette("/scenario/show") do
        scenario = DocomoNlu::Management::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        VCR.use_cassette("/scenario/delete") do
          expect(scenario.destroy.code).to eq "204"
        end
      end
    end
  end
end
