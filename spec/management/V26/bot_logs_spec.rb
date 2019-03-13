# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::BotLogs do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#bot_logs" do
    let(:project_id) { 176 }
    let(:bot_id) { "176_89_main" }
    let(:params) { { start: "20190312", end: "20190313" } }
    let(:bot_logs) { DocomoNlu::Management::BotLogs.new(project_id: project_id) }

    it "Get all logs" do
      VCR.use_cassette("/V26/bot_logs") do
        expect(bot_logs.download(bot_id).is_a? Tempfile).to be_truthy
        expect(bot_logs.logs.blank?).to be_falsey
      end
    end

    it "Get logs using query" do
      VCR.use_cassette("/V26/bot_logs/query") do
        expect(bot_logs.download(bot_id, params).is_a? Tempfile).to be_truthy
        expect(bot_logs.logs.blank?).to be_falsey
      end
    end
  end
end
