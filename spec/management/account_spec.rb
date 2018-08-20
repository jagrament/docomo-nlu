RSpec.describe DocomoNlu::Management::Account do
  describe '#Initilize' do
    it 'access_token successfully loading' do
      account = DocomoNlu::Management::Account.new
      expect(account.access_token).to eq DocomoNlu.config.admin_access_token
    end
  end

  describe '#accounts' do
    it 'Get all accounts' do
      stub_request(:get,'https://example.com/management/v2.2/accounts').to_return(body: stub_file('management/accounts.json'))
      accounts = DocomoNlu::Management::Account.all
      expect(accounts.first.accountId).to eq 1
      expect(accounts.last.accountId).to eq 2
    end

    it 'Get an account' do
      stub_request(:get,'https://example.com/management/v2.2/accounts/1').to_return(body: stub_file('management/account.json'))
      account = DocomoNlu::Management::Account.find(1)
      expect(account.accountId).to eq 1
      expect(account.accountName).to eq 'test_account'
    end

    it 'Create an account' do
      stub_request(:post,'https://example.com/management/v2.2/accounts').to_return(body: stub_file('management/account_save.json'))
      account = DocomoNlu::Management::Account.new({ accountName: "test_account", password: 'testtest', authorization: 2, enable: true})
      account.save
      expect(account.accountId).to eq 1
    end

  end
end
