# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Logs do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#bots" do
    let(:project_id) { 176 }
    let(:params) { { details: [{ operation: "", target: "input", query: "Hello" }]} }

    it "Get count all logs" do
      VCR.use_cassette("/V26/logs/count") do
        logs = DocomoNlu::Management::Logs.new(project_id: project_id)
        expect(logs.count).not_to be_nil
      end
    end

    it "Get count qieru logs" do
      VCR.use_cassette("/V26/logs/count/query") do
        logs = DocomoNlu::Management::Logs.new(project_id: project_id)
        expect(logs.count(params)).not_to be_nil
      end
    end
    it "Get all logs" do
      VCR.use_cassette("/V26/logs") do
        logs = DocomoNlu::Management::Logs.new(project_id: project_id)
        expect(logs.download).not_to be_nil
      end
    end

    it "Get logs using query" do
      VCR.use_cassette("/V26/logs/query") do
        logs = DocomoNlu::Management::Logs.new(project_id: project_id)
        expect(logs.download(params)).not_to be_nil
      end
    end
  end
end
