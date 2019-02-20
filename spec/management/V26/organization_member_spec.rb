# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::OrganizationMember do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#organizationMembers" do
    let(:organization_id) { 41 }
    let(:account_id) { 42 }

    it "Add a member" do
      VCR.use_cassette("/V26/organization_member/create") do
        member = DocomoNlu::Management::V26::OrganizationMember.new(accountIds: [{ accountId: account_id }])
        member.prefix_options[:organization_id] = organization_id
        member.save
      end
    end

    it "Get members" do
      VCR.use_cassette("/V26/organization_member/index") do
        member = DocomoNlu::Management::V26::OrganizationMember.all(params: { organization_id: organization_id }).first
        expect(member.accountId).to eq account_id
      end
    end

    it "Delete a member" do
      VCR.use_cassette("/V26/organization_member/index") do
        member = DocomoNlu::Management::V26::OrganizationMember.where(organization_id: organization_id).first
        VCR.use_cassette("/V26/organization_member/delete") do
          expect(member.destroy.code).to eq "204"
        end
      end
    end

    it "Get members with 404" do
      VCR.use_cassette("/V26/organization_member/index_404") do
        members = DocomoNlu::Management::V26::OrganizationMember.find(:all, params: { organization_id: 216 })
        expect(members).to eq nil
      end
    end

    it "members not found" do
      VCR.use_cassette("/V26/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V26::OrganizationMember.where(organization_id: organization_id).first).
          to eq nil
      end
      VCR.use_cassette("/V26/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V26::OrganizationMember.find(:all, params: { organization_id: organization_id }).first).
          to eq nil
      end
      VCR.use_cassette("/V26/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V26::OrganizationMember.all(params: { organization_id: organization_id }).first).
          to eq nil
      end
    end
  end
end
