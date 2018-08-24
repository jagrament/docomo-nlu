RSpec.describe DocomoNlu::Management::Account do
  describe "#accounts" do
    it "Get all accounts" do
      VCR.use_cassette("/account/index") do
        accounts = DocomoNlu::Management::Account.all
        expect(accounts.first.accountId).not_to be_nil
      end
    end

    it "Create an account" do
      VCR.use_cassette("/account/create") do
        account = DocomoNlu::Management::Account.new({ accountName: "test_account", password: "testaccount20180821", authorization: 2, enable: true })
        account.save
        expect(account.accountId).to eq 236
      end
    end

    it "Get an account" do
      VCR.use_cassette("/account/show") do
        account = DocomoNlu::Management::Account.find(236)
        expect(account.id).to eq 236
      end
    end

    it "Update an account" do
      VCR.use_cassette("/account/show") do
        account = DocomoNlu::Management::Account.find(236)
        VCR.use_cassette("/account/update") do
          account.accountName = "update account"
          account.description = "update account"
          expect(account.save).to eq true
        end
      end
    end

    it "Delete an account" do
      VCR.use_cassette("/account/show") do
        account = DocomoNlu::Management::Account.find(236)
        VCR.use_cassette("/account/delete") do
          expect(account.destroy.code).to eq "204"
        end
      end
    end

    it "Count all accounts" do
      VCR.use_cassette("/account/count") do
        expect(DocomoNlu::Management::Account.count).to eq 207
      end
    end
  end
end
