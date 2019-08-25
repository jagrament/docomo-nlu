# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Base do
  describe "#Initilize" do
    it "Access_token successfully loading" do
      base = described_class.new
      expect(base.access_token).to eq DocomoNlu.config.admin_access_token
    end
  end

  describe "#Authorization" do
    let(:admin_access_token) { DocomoNlu.config.admin_access_token }
    let(:account) { "test_account" }
    let(:password) { "testaccount20180821" }

    it "Login Error::BadRequest" do
      VCR.use_cassette("/management/base/login_400") do
        base = described_class.new
        expect { base.login("account", "password") }.to raise_error(ActiveResource::BadRequest)
      end
    end

    it "Login Success" do
      VCR.use_cassette("/management/base/login") do
        base = described_class.new
        base.login(account, password)
        expect(base.access_token).not_to be_nil
        expect(base.access_token).not_to eq admin_access_token
      end
    end

    it "Logout Success" do
      VCR.use_cassette("/management/base/login") do
        base = described_class.new
        base.login(account, password)
        VCR.use_cassette("/management/base/logout") do
          expect(base.logout).to eq true
          expect(base.access_token).to eq nil
        end
      end
    end

    it "Logout Error::BadRequest" do
      VCR.use_cassette("/management/base/logout_400") do
        base = described_class.new
        base.access_token = "dummy"
        expect { base.logout }.to raise_error(ActiveResource::UnauthorizedAccess)
      end
    end
  end
end
