# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Base do
  describe "#Initilize" do
    it "Access_token successfully loading" do
      base = DocomoNlu::Management::V23::Base.new
      expect(base.access_token).to eq DocomoNlu.config.admin_access_token
    end
  end

  describe "#Authorization" do
    let(:admin_access_token) { DocomoNlu.config.admin_access_token }

    it "Login Error::BadRequest" do
      VCR.use_cassette("/V23/base/login_400") do
        base = DocomoNlu::Management::V23::Base.new
        expect { base.login("account", "password") }.to raise_error(ActiveResource::BadRequest)
      end
    end

    it "Login Success" do
      VCR.use_cassette("/V23/base/login") do
        base = DocomoNlu::Management::V23::Base.new
        base.login("test_account1", "testaccount20180821")
        expect(base.access_token).not_to be_nil
        expect(base.access_token).not_to eq admin_access_token
      end
    end

    it "Logout Success" do
      VCR.use_cassette("/V23/base/logout") do
        base = DocomoNlu::Management::V23::Base.new
        expect(base.logout).to eq true
        expect(base.access_token).to eq nil
      end
    end

    it "Logout Error::BadRequest" do
      VCR.use_cassette("/V23/base/logout_400") do
        base = DocomoNlu::Management::V23::Base.new
        base.access_token = "dummy"
        expect { base.logout }.to raise_error(ActiveResource::BadRequest)
      end
    end
  end
end
