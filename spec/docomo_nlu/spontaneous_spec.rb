# frozen_string_literal: true

RSpec.describe DocomoNlu::Spontaneous do
  describe "#registration" do
    it "success" do
      VCR.use_cassette("/spontaneous/registration") do
        s = DocomoNlu::Spontaneous.new
        s.botId = "test_bot"
        expect(s.registration).not_to be_nil
      end
    end
    it "error" do
      VCR.use_cassette("/spontaneous/registration_404") do
        s = DocomoNlu::Spontaneous.new
        expect { s.registration }.to raise_error ActiveResource::BadRequest
      end
    end
  end

  describe "#dialogue" do
    it "success" do
      s = DocomoNlu::Spontaneous.new
      s.botId = "test_bot"
      VCR.use_cassette("/spontaneous/registration") do
        s.registration
        VCR.use_cassette("/spontaneous/dialogue") do
          expect(s.dialogue("init")).not_to be_nil
        end
      end
    end
    it "error" do
      VCR.use_cassette("/spontaneous/dialogue_404") do
        s = DocomoNlu::Spontaneous.new
        expect { s.dialogue("init") }.to raise_error ActiveResource::BadRequest
      end
    end
  end
end
