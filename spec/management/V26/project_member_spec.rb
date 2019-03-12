# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::ProjectMember do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  let(:project_id) { 40 }
  let(:account_id) { 42 }

  describe "#projectMembers" do
    it "Add a member" do
      VCR.use_cassette("/V26/project_member/create") do
        member = DocomoNlu::Management::V26::ProjectMember.new(accountIds: [{ accountId: account_id }])
        member.prefix_options[:project_id] = project_id
        member.save
      end
    end

    it "Get members" do
      VCR.use_cassette("/V26/project_member/index") do
        member = DocomoNlu::Management::V26::ProjectMember.all(params: { project_id: project_id }).first
        expect(member.accountId).to eq account_id
      end
    end

    it "Delete a member" do
      VCR.use_cassette("/V26/project_member/index") do
        member = DocomoNlu::Management::V26::ProjectMember.where(project_id: project_id).first
        VCR.use_cassette("/V26/project_member/delete") do
          expect(member.destroy.code).to eq "204"
        end
      end
    end

    it "Get members with 404" do
      VCR.use_cassette("/V26/project_member/index_403") do
        expect { DocomoNlu::Management::V26::ProjectMember.find(:all, params: { project_id: 0 }) }.
          to raise_error(ActiveResource::ForbiddenAccess)
      end
    end

    it "members not found" do
      VCR.use_cassette("/V26/project_member/index_not_found") do
        expect(DocomoNlu::Management::V26::ProjectMember.where(project_id: project_id).first).
          to eq nil
      end
      VCR.use_cassette("/V26/project_member/index_not_found") do
        expect(DocomoNlu::Management::V26::ProjectMember.find(:all, params: { project_id: project_id }).first).
          to eq nil
      end
      VCR.use_cassette("/V26/project_member/index_not_found") do
        expect(DocomoNlu::Management::V26::ProjectMember.all(params: { project_id: project_id }).first).
          to eq nil
      end
    end
  end
end
