# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Project do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#projects" do
    let(:organization_id) { 1 }
    let(:name) { "testproject" }
    ID = nil

    it "Get all projects" do
      VCR.use_cassette("/management/project/index") do
        projects = DocomoNlu::Management::Project.all
        expect(projects.first.projectId).not_to be_nil
      end
    end

    it "Create an project" do
      VCR.use_cassette("/management/project/create") do
        project = DocomoNlu::Management::Project.new(projectName: name, organizationId: organization_id)
        expect(project.save).to eq true
        ID = project.id
      end
    end

    it "Conflict project name" do
      VCR.use_cassette("/management/project/create_conflict") do
        project = DocomoNlu::Management::Project.new(projectName: name, organizationId: organization_id)
        expect { project.save }.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it "Get an project" do
      VCR.use_cassette("/management/project/show") do
        project = DocomoNlu::Management::Project.find(ID)
        expect(project.id).to eq ID
      end
    end

    it "Delete an project" do
      VCR.use_cassette("/management/project/show") do
        project = DocomoNlu::Management::Project.find(ID)
        VCR.use_cassette("/management/project/delete") do
          expect(project.destroy.code).to eq "204"
        end
      end
    end
  end
end
