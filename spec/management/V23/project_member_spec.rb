# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::ProjectMember do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#projectMembers" do
    it "Add a member" do
      VCR.use_cassette("/V23/project_member/create") do
        member = DocomoNlu::Management::V23::ProjectMember.new(accountIds: [{ accountId: 237 }])
        member.prefix_options[:project_id] = 212
        member.save
      end
    end

    it "Get members" do
      VCR.use_cassette("/V23/project_member/index") do
        member = DocomoNlu::Management::V23::ProjectMember.all(params: { project_id: 212 }).first
        expect(member.accountId).to eq 237
      end
    end

    it "Delete a member" do
      VCR.use_cassette("/V23/project_member/index") do
        member = DocomoNlu::Management::V23::ProjectMember.where(project_id: 212).first
        VCR.use_cassette("/V23/project_member/delete") do
          expect(member.destroy.code).to eq "204"
        end
      end
    end

    it "Get members with 404" do
      VCR.use_cassette("/V23/project_member/index_403") do
        expect { DocomoNlu::Management::V23::ProjectMember.find(:all, params: { project_id: 213 }) }.
          to raise_error(ActiveResource::ForbiddenAccess)
      end
    end

    it "members not found" do
      VCR.use_cassette("/V23/project_member/index_not_found") do
        expect(DocomoNlu::Management::V23::ProjectMember.where(project_id: 212).first).
          to eq nil
      end
      VCR.use_cassette("/V23/project_member/index_not_found") do
        expect(DocomoNlu::Management::V23::ProjectMember.find(:all, params: { project_id: 212 }).first).
          to eq nil
      end
      VCR.use_cassette("/V23/project_member/index_not_found") do
        expect(DocomoNlu::Management::V23::ProjectMember.all(params: { project_id: 212 }).first).
          to eq nil
      end
    end
  end
end
