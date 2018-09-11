# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Config do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#configs" do
    it "Get configs" do
      VCR.use_cassette("config/index") do
        configs = DocomoNlu::Management::Config.all(params: { project_id: 212, bot_id: "test_bot" })
        expect(configs.first.sraix).to eq false

        configs = DocomoNlu::Management::Config.find(:all, params: { project_id: 212, bot_id: "test_bot" })
        expect(configs.first.sraix).to eq false

        configs = DocomoNlu::Management::Config.where(project_id: 212, bot_id: "test_bot")
        expect(configs.first.sraix).to eq false
      end
    end

    it "Update configs" do
      VCR.use_cassette("config/index") do
        config = DocomoNlu::Management::Config.all(params: { project_id: 212, bot_id: "test_bot" }).first
        VCR.use_cassette("config/update") do
          config.testUrl = "https://example.com/api/"
          expect(config.save).to eq true
        end
      end
    end

    it "Delete configs" do
      VCR.use_cassette("config/index") do
        config = DocomoNlu::Management::Config.all(params: { project_id: 212, bot_id: "test_bot" }).first
        VCR.use_cassette("config/delete") do
          expect(config.destroy(["testurl"]).code).to eq "204"
        end
      end
    end
  end
end
