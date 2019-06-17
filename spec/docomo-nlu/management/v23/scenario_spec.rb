# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Scenario do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#scenarios" do
    it "Create a scenario" do
      VCR.use_cassette("/V23/scenario/create") do
        scenario = DocomoNlu::Management::V23::Scenario.new(userScenarios: [{ scenarioId: "test_scenario", description: "test", compileFlag: true }])
        scenario.prefix_options["project_id"] = 212
        scenario.prefix_options["bot_id"] = "test_bot"
        expect(scenario.save).to eq true
      end
    end

    it "Get all scenarios" do
      VCR.use_cassette("/V23/scenario/index") do
        scenarios = DocomoNlu::Management::V23::Scenario.all(params: { project_id: 212, bot_id: "test_bot" })
        expect(scenarios.first.userScenarios.first.scenarioId).not_to be_nil
      end
    end

    it "Conflict scenario Id" do
      VCR.use_cassette("/V23/scenario/create_conflict") do
        scenario = DocomoNlu::Management::V23::Scenario.new(userScenarios: [{ scenarioId: "test_scenario", description: "test", compileFlag: true }])
        scenario.prefix_options["project_id"] = 212
        scenario.prefix_options["bot_id"] = "test_bot"
        expect { scenario.save }.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it "Get a scenario" do
      VCR.use_cassette("/V23/scenario/show") do
        scenario = DocomoNlu::Management::V23::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        expect(scenario.userScenarios.first.scenarioId).to eq "test_scenario"
      end
    end

    it "Update a scenario (compileFlag)" do
      VCR.use_cassette("/V23/scenario/show") do
        scenario = DocomoNlu::Management::V23::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        VCR.use_cassette("/V23/scenario/update") do
          scenario.userScenarios.map {|us| us.compileFlag = true }
          expect(scenario.save).to eq true
        end
      end
    end

    describe "#aiml" do
      context "Upload file" do
        it "Upload AIML" do
          VCR.use_cassette("/V23/scenario/upload_aiml") do
            scenario = DocomoNlu::Management::V23::Scenario.new(project_id: 212, bot_id: "test_bot")
            scenario.prefix_options[:method] = :aiml
            response = scenario.upload(stub_file("test.aiml"))
            expect(response).to eq true
          end
        end

        it "Upload dat" do
          VCR.use_cassette("/V23/scenario/upload_dat") do
            scenario = DocomoNlu::Management::V23::Scenario.new(project_id: 212, bot_id: "test_bot")
            scenario.prefix_options[:method] = :dat
            response = scenario.upload(stub_file("test.dat"))
            expect(response).to eq true
          end
        end

        it "Upload zip" do
          VCR.use_cassette("/V23/scenario/upload_archive") do
            scenario = DocomoNlu::Management::V23::Scenario.new(project_id: 212, bot_id: "test_bot")
            scenario.prefix_options[:method] = :archive
            response = scenario.upload(stub_file("test.zip"))
            expect(response).to eq true
          end
        end
      end

      context "Download file" do
        it "Donwload aiml" do
          scenario = DocomoNlu::Management::V23::Scenario.new(project_id: 212, bot_id: "test_bot")
          VCR.use_cassette("/V23/scenario/download_aiml") do
            scenario.prefix_options[:method] = :aiml
            scenario.download("test")
            expect(scenario.file).not_to be_nil
          end
        end
      end

      it "Deploy scenario" do
        VCR.use_cassette("/V23/scenario/deploy") do
          scenario = DocomoNlu::Management::V23::Scenario.new(project_id: 212, bot_id: "test_bot")
          expect(scenario.deploy).to eq true
        end
      end
    end

    it "Delete a scenario" do
      VCR.use_cassette("/V23/scenario/show") do
        scenario = DocomoNlu::Management::V23::Scenario.find("test_scenario", params: { project_id: 212, bot_id: "test_bot" })
        VCR.use_cassette("/V23/scenario/delete") do
          expect(scenario.destroy("test_scenario").code).to eq "204"
        end
      end
    end
  end
end
