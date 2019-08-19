# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Provider do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#providers" do
    ORGANIZATION_ID = 40
    ID = nil

    it "Get all providers" do
      VCR.use_cassette("/management/provider/index") do
        providers = described_class.all
        expect(providers.first.providerId).not_to be_nil
      end
    end

    it "Create an provider" do
      VCR.use_cassette("/management/provider/create") do
        provider = described_class.new(organizationId: ORGANIZATION_ID, serverKind: "SS", serverId: "DSU")
        expect(provider.save).to eq true
        ID = provider.id
      end
    end

    it "Get an provider" do
      VCR.use_cassette("/management/provider/show") do
        provider = described_class.find(ID)
        expect(provider.id).to eq ID
      end
    end

    it "Delete an provider" do
      VCR.use_cassette("/management/provider/show") do
        provider = described_class.find(ID)
        VCR.use_cassette("/management/provider/delete") do
          expect(provider.destroy.code).to eq "204"
        end
      end
    end
  end
end
