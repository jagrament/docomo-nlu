# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Provider do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#providers" do
    ORGANIZATION_ID = 40
    ID = nil

    it "Get all providers" do
      VCR.use_cassette("/V26/provider/index") do
        providers = DocomoNlu::Management::V26::Provider.all
        expect(providers.first.providerId).not_to be_nil
      end
    end

    it "Create an provider" do
      VCR.use_cassette("/V26/provider/create") do
        provider = DocomoNlu::Management::V26::Provider.new(organizationId: ORGANIZATION_ID, serverKind: "SS", serverId: "DSU")
        expect(provider.save).to eq true
        ID = provider.id
      end
    end

    it "Get an provider" do
      VCR.use_cassette("/V26/provider/show") do
        provider = DocomoNlu::Management::V26::Provider.find(ID)
        expect(provider.id).to eq ID
      end
    end

    it "Delete an provider" do
      VCR.use_cassette("/V26/provider/show") do
        provider = DocomoNlu::Management::V26::Provider.find(ID)
        VCR.use_cassette("/V26/provider/delete") do
          expect(provider.destroy.code).to eq "204"
        end
      end
    end
  end
end
