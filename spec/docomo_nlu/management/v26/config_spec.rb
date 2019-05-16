# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Config do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#configs" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    it "Get configs" do
      VCR.use_cassette("/V26/config/index") do
        configs = DocomoNlu::Management::V26::Config.all(params: { project_id: project_id, bot_id: bot_id })
        expect(configs).not_to be nil

        configs = DocomoNlu::Management::V26::Config.find(:all, params: { project_id: project_id, bot_id: bot_id })
        expect(configs).not_to be nil

        configs = DocomoNlu::Management::V26::Config.where(project_id: project_id, bot_id: bot_id)
        expect(configs).not_to be nil
      end
    end

    it "Update configs" do
      VCR.use_cassette("/V26/config/show") do
        config = DocomoNlu::Management::V26::Config.find("", params: { project_id: project_id, bot_id: bot_id })
        VCR.use_cassette("/V26/config/update") do
          config.test_Url = "https://example.com/api/"
          expect(config.save).to eq true
        end
      end
    end

    it "Delete configs" do
      VCR.use_cassette("/V26/config/show") do
        config = DocomoNlu::Management::V26::Config.find("", params: { project_id: project_id, bot_id: bot_id })
        VCR.use_cassette("/V26/config/delete") do
          expect(config.destroy(["test_Url"]).code).to eq "204"
        end
      end
    end
  end
end
