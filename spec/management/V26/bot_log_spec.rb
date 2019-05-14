# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::BotLog do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#bot_logs" do
    let(:project_id) { 176 }
    let(:bot_id) { "176_89_main" }
    let(:params) { { start: "20190312", end: "20190313" } }
    let(:bot_log) { DocomoNlu::Management::BotLog.new(project_id: project_id) }

    it "Get all logs" do
      VCR.use_cassette("/V26/bot_log/all") do
        expect(bot_log.download(bot_id)).to be_a(Tempfile)
      end
    end

    it "Get all Logs and parse data" do
      VCR.use_cassette("/V26/bot_log/all") do
        bot_log.download(bot_id, { is_extract: true })
        expect(bot_log.extract_data).to be_truthy
        expect(bot_log.extract_data).to be_a(Array)
      end
    end

    it "Get logs using query" do
      VCR.use_cassette("/V26/bot_log/query") do
        expect(bot_log.download(bot_id, params)).to be_a(Tempfile)
      end
    end
  end
end
