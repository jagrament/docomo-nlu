# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Account do
  describe "#accounts" do
    ID = nil
    it "Get all accounts" do
      VCR.use_cassette("/V26/account/index") do
        accounts = DocomoNlu::Management::V26::Account.all
        expect(accounts.first.accountId).not_to be_nil
      end
    end

    it "Create an account" do
      VCR.use_cassette("/V26/account/create") do
        account = DocomoNlu::Management::V26::Account.new(accountName: "test_account", password: "testaccount20180821", authorization: 2, enable: true, eternity: true)
        account.save
        expect(account.accountId).not_to be_nil
        ID = account.id
      end
    end

    it "Get an account" do
      VCR.use_cassette("/V26/account/show") do
        account = DocomoNlu::Management::V26::Account.find(ID)
        expect(account.id).not_to be_nil
      end
    end

    it "Update an account" do
      VCR.use_cassette("/V26/account/show") do
        account = DocomoNlu::Management::V26::Account.find(ID)
        VCR.use_cassette("/V26/account/update") do
          account.accountName = "update account"
          account.description = "update account"
          expect(account.save).to eq true
        end
      end
    end

    it "Delete an account" do
      VCR.use_cassette("/V26/account/show") do
        account = DocomoNlu::Management::V26::Account.find(ID)
        VCR.use_cassette("/V26/account/delete") do
          expect(account.destroy.code).to eq "204"
        end
      end
    end

    it "Count all accounts" do
      VCR.use_cassette("/V26/account/count") do
        expect(DocomoNlu::Management::V26::Account.count).to eq 39
      end
    end
  end
end
