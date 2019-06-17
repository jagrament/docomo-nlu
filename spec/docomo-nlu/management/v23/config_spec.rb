# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Config do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#configs" do
    it "Get configs" do
      VCR.use_cassette("/V23/config/index") do
        configs = DocomoNlu::Management::V23::Config.all(params: { project_id: 212, bot_id: "test_bot" })
        expect(configs.first.sraix).to eq false

        configs = DocomoNlu::Management::V23::Config.find(:all, params: { project_id: 212, bot_id: "test_bot" })
        expect(configs.first.sraix).to eq false

        configs = DocomoNlu::Management::V23::Config.where(project_id: 212, bot_id: "test_bot")
        expect(configs.first.sraix).to eq false
      end
    end

    it "Update configs" do
      VCR.use_cassette("/V23/config/index") do
        config = DocomoNlu::Management::V23::Config.all(params: { project_id: 212, bot_id: "test_bot" }).first
        VCR.use_cassette("/V23/config/update") do
          config.testUrl = "https://example.com/api/"
          expect(config.save).to eq true
        end
      end
    end

    it "Delete configs" do
      VCR.use_cassette("/V23/config/index") do
        config = DocomoNlu::Management::V23::Config.all(params: { project_id: 212, bot_id: "test_bot" }).first
        VCR.use_cassette("/V23/config/delete") do
          expect(config.destroy(["testurl"]).code).to eq "204"
        end
      end
    end
  end
end
