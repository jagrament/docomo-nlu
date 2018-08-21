RSpec.describe DocomoNlu::Management::Project do
  describe '#projects' do

    it 'Get all projects' do
      VCR.use_cassette('/project/index') do
        projects = DocomoNlu::Management::Project.all
        expect(projects.first.projectId).not_to be_nil
      end
    end

    it 'Create an project' do
      VCR.use_cassette('/project/create') do
        project = DocomoNlu::Management::Project.new({ projectName: "testproject", organizationId: 215})
        expect(project.save).to eq true
      end
    end

    it 'Conflict project name' do
      VCR.use_cassette('/project/create_conflict') do
        project = DocomoNlu::Management::Project.new({ projectName: "testproject", organizationId: 215})
        expect{project.save}.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it 'Get an project' do
      VCR.use_cassette('/project/show') do
        project = DocomoNlu::Management::Project.find(213)
        expect(project.id).to eq 213
      end
    end

    it 'Delete an project' do
      VCR.use_cassette('/project/show') do
        project = DocomoNlu::Management::Project.find(213)
        VCR.use_cassette('/project/delete') do
          expect(project.destroy.code).to eq '204'
        end
      end
    end
  end
end
