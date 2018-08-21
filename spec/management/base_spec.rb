RSpec.describe DocomoNlu::Management::Base do
  describe '#Initilize' do
    it 'Access_token successfully loading' do
      base = DocomoNlu::Management::Base.new
      expect(base.access_token).to eq DocomoNlu.config.admin_access_token
    end
  end

  describe '#Authorization' do
    let(:host){ DocomoNlu.config.nlu_host }
    let(:version){ DocomoNlu.config.nlu_version }
    it 'Login Success' do
      stub_request(:post,"#{host}/management/#{version}/login").to_return(body: '{"accessToken":"test_token"}')
      base = DocomoNlu::Management::Base.new
      base.login('account','password')
      expect(base.access_token).to eq 'test_token'
    end

    it 'Login Error::BadRequest' do
      stub_request(:post,"#{host}/management/#{version}/login").to_return(status: 400)
      base = DocomoNlu::Management::Base.new
      expect{base.login('account','password')}.to raise_error(ActiveResource::BadRequest)
    end

    it 'Logout Success' do
      stub_request(:get,"#{host}/management/#{version}/logout")
        .to_return(body: '', status: 200)
      base = DocomoNlu::Management::Base.new
      base.logout
      expect(base.access_token).to eq nil
    end

    it 'Logout Error::BadRequest' do
      stub_request(:get,"#{host}/management/#{version}/logout")
        .to_return(status: 400)
      DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
      base = DocomoNlu::Management::Base.new
      expect{base.logout}.to raise_error(ActiveResource::BadRequest)
    end

    it 'Logout Error::UnauthorizedAccess' do
      stub_request(:get,"#{host}/management/#{version}/logout")
        .to_return(status: 401)
      DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
      base = DocomoNlu::Management::Base.new
      expect{base.logout}.to raise_error(ActiveResource::UnauthorizedAccess)
    end

  end

end
