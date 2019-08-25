# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Account do
  describe "#accounts" do
    ID = nil
    it "Get all accounts" do
      VCR.use_cassette("/management/account/index") do
        accounts = described_class.all
        expect(accounts.first.accountId).not_to be_nil
      end
    end

    it "Create an account" do
      VCR.use_cassette("/management/account/create") do
        attributes = { accountName: "test_account", password: "testaccount20180821", authorization: 2, enable: true, eternity: true }
        account = described_class.new(attributes)
        account.save
        expect(account.accountId).not_to be_nil
        ID = account.id
      end
    end

    it "Get an account" do
      VCR.use_cassette("/management/account/show") do
        account = described_class.find(ID)
        expect(account.id).not_to be_nil
      end
    end

    it "Update an account" do
      VCR.use_cassette("/management/account/show") do
        account = described_class.find(ID)
        VCR.use_cassette("/management/account/update") do
          account.accountName = "update account"
          account.description = "update account"
          expect(account.save).to eq true
        end
      end
    end

    it "Delete an account" do
      VCR.use_cassette("/management/account/show") do
        account = described_class.find(ID)
        VCR.use_cassette("/management/account/delete") do
          expect(account.destroy.code).to eq "204"
        end
      end
    end

    it "Count all accounts" do
      VCR.use_cassette("/management/account/count") do
        expect(described_class.count).to eq 39
      end
    end
  end
end
