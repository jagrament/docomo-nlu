# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Project do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#projects" do
    it "Get all projects" do
      VCR.use_cassette("/V23/project/index") do
        projects = DocomoNlu::Management::V23::Project.all
        expect(projects.first.projectId).not_to be_nil
      end
    end

    it "Create an project" do
      VCR.use_cassette("/V23/project/create") do
        project = DocomoNlu::Management::V23::Project.new(projectName: "testproject1", organizationId: 215)
        expect(project.save).to eq true
      end
    end

    it "Conflict project name" do
      VCR.use_cassette("/V23/project/create_conflict") do
        project = DocomoNlu::Management::V23::Project.new(projectName: "testproject1", organizationId: 215)
        expect { project.save }.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it "Get an project" do
      VCR.use_cassette("/V23/project/show") do
        project = DocomoNlu::Management::V23::Project.find(551)
        expect(project.id).to eq 551
      end
    end

    it "Delete an project" do
      VCR.use_cassette("/V23/project/show") do
        project = DocomoNlu::Management::V23::Project.find(551)
        VCR.use_cassette("/V23/project/delete") do
          expect(project.destroy.code).to eq "204"
        end
      end
    end
  end
end
