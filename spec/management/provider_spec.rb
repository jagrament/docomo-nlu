# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Provider do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe '#providers' do
    it 'Get all providers' do
      VCR.use_cassette('/provider/index') do
        providers = DocomoNlu::Management::Provider.all
        expect(providers.first.providerId).not_to be_nil
      end
    end

    it 'Create an provider' do
      VCR.use_cassette('/provider/create') do
        provider = DocomoNlu::Management::Provider.new(organizationId: '215', serverKind: 'SS', serverId: 'DSU')
        expect(provider.save).to eq true
      end
    end

    it 'Get an provider' do
      VCR.use_cassette('/provider/show') do
        provider = DocomoNlu::Management::Provider.find(219)
        expect(provider.id).to eq 219
      end
    end

    it 'Delete an provider' do
      VCR.use_cassette('/provider/show') do
        provider = DocomoNlu::Management::Provider.find(219)
        VCR.use_cassette('/provider/delete') do
          expect(provider.destroy.code).to eq '204'
        end
      end
    end
  end
end
