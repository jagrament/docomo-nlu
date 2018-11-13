# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Provider do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#providers" do
    it "Get all providers" do
      VCR.use_cassette("/V23/provider/index") do
        providers = DocomoNlu::Management::V23::Provider.all
        expect(providers.first.providerId).not_to be_nil
      end
    end

    it "Create an provider" do
      VCR.use_cassette("/V23/provider/create") do
        provider = DocomoNlu::Management::V23::Provider.new(organizationId: "215", serverKind: "SS", serverId: "DSU")
        expect(provider.save).to eq true
      end
    end

    it "Get an provider" do
      VCR.use_cassette("/V23/provider/show") do
        provider = DocomoNlu::Management::V23::Provider.find(219)
        expect(provider.id).to eq 219
      end
    end

    it "Delete an provider" do
      VCR.use_cassette("/V23/provider/show") do
        provider = DocomoNlu::Management::V23::Provider.find(219)
        VCR.use_cassette("/V23/provider/delete") do
          expect(provider.destroy.code).to eq "204"
        end
      end
    end
  end
end
