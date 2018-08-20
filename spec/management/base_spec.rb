RSpec.describe DocomoNlu::Management::Base do
  describe '#Initilize' do
    it 'access_token successfully loading' do
      base = DocomoNlu::Management::Base.new
      expect(base.access_token).to eq DocomoNlu.config.admin_access_token
    end
  end

  describe '#Authorization' do
    it 'login' do
      stub_request(:post,'https://example.com/management/v2.2/login').to_return(body: '{"accessToken":"test_token"}')
      base = DocomoNlu::Management::Base.new
      base.login('account','password')
      expect(base.access_token).to eq 'test_token'
    end

    it 'logout' do
      stub_request(:get,'https://example.com/management/v2.2/logout')
        .to_return(body: '', status: 200)
      base = DocomoNlu::Management::Base.new
      base.logout
      expect(base.access_token).to eq nil
    end
  end

end
