# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::OrganizationMember do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#organizationMembers" do
    it "Add a member" do
      VCR.use_cassette("/V23/organization_member/create") do
        member = DocomoNlu::Management::V23::OrganizationMember.new(accountIds: [{ accountId: 606 }])
        member.prefix_options[:organization_id] = 215
        member.save
      end
    end

    it "Get members" do
      VCR.use_cassette("/V23/organization_member/index") do
        member = DocomoNlu::Management::V23::OrganizationMember.all(params: { organization_id: 215 }).first
        expect(member.accountId).to eq 606
      end
    end

    it "Delete a member" do
      VCR.use_cassette("/V23/organization_member/index") do
        member = DocomoNlu::Management::V23::OrganizationMember.where(organization_id: 215).first
        VCR.use_cassette("/V23/organization_member/delete") do
          expect(member.destroy.code).to eq "204"
        end
      end
    end

    it "Get members with 404" do
      VCR.use_cassette("/V23/organization_member/index_404") do
        members = DocomoNlu::Management::V23::OrganizationMember.find(:all, params: { organization_id: 0o0 })
        expect(members).to eq nil
      end
    end

    it "members not found" do
      VCR.use_cassette("/V23/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V23::OrganizationMember.where(organization_id: 215).first).
          to eq nil
      end
    end
    it "members not found with find" do
      VCR.use_cassette("/V23/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V23::OrganizationMember.find(:all, params: { organization_id: 215 }).first).
          to eq nil
      end
    end
    it "members not found with all" do
      VCR.use_cassette("/V23/organization_member/index_not_found") do
        expect(DocomoNlu::Management::V23::OrganizationMember.all(params: { organization_id: 215 }).first).
          to eq nil
      end
    end
  end
end
