# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::OrganizationMember do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#organizationMembers" do
    let(:organization_id) { 41 }
    let(:account_id) { 42 }

    it "Add a member" do
      VCR.use_cassette("/management/organization_member/create") do
        member = described_class.new(accountIds: [{ accountId: account_id }])
        member.prefix_options[:organization_id] = organization_id
        member.save
      end
    end

    it "Get members" do
      VCR.use_cassette("/management/organization_member/index") do
        member = described_class.all(params: { organization_id: organization_id }).first
        expect(member.accountId).to eq account_id
      end
    end

    it "Delete a member" do
      VCR.use_cassette("/management/organization_member/index") do
        member = described_class.where(organization_id: organization_id).first
        VCR.use_cassette("/management/organization_member/delete") do
          expect(member.destroy.code).to eq "204"
        end
      end
    end

    it "Get members with 404" do
      VCR.use_cassette("/management/organization_member/index_404") do
        members = described_class.find(:all, params: { organization_id: 216 })
        expect(members).to eq nil
      end
    end

    it "members not found" do
      VCR.use_cassette("/management/organization_member/index_not_found") do
        expect(described_class.where(organization_id: organization_id).first).
          to eq nil
      end
    end
    it "members not found with find" do
      VCR.use_cassette("/management/organization_member/index_not_found") do
        expect(described_class.find(:all, params: { organization_id: organization_id }).first).
          to eq nil
      end
    end
    it "members not found with all" do
      VCR.use_cassette("/management/organization_member/index_not_found") do
        expect(described_class.all(params: { organization_id: organization_id }).first).
          to eq nil
      end
    end
  end
end
