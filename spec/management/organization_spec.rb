RSpec.describe DocomoNlu::Management::Organization do
  describe '#organizations' do

    it 'Get all organizations' do
      VCR.use_cassette('/organization/index') do
        organizations = DocomoNlu::Management::Organization.all
        expect(organizations.first.organizationId).not_to be_nil
      end
    end

    it 'Create an organization' do
      VCR.use_cassette('/organization/create') do
        organization = DocomoNlu::Management::Organization.new({ organizationName: "test_organization", address: 'test_address', tel: 'test_tel' })
        expect(organization.save).to eq true
      end
    end

    it 'Get an organization' do
      VCR.use_cassette('/organization/show') do
        organization = DocomoNlu::Management::Organization.find(214)
        expect(organization.organizationId).to eq 214
      end
    end

    it 'Update an organization' do
      VCR.use_cassette('/organization/show') do
        organization = DocomoNlu::Management::Organization.find(214)
        VCR.use_cassette('/organization/update') do
          organization.organizationName = 'update_organizationName'
          expect(organization.save).to eq true
        end
      end
    end

    it 'Delete an organization' do
      VCR.use_cassette('/organization/show') do
        organization = DocomoNlu::Management::Organization.find(214)
        VCR.use_cassette('/organization/delete') do
          expect(organization.destroy.code).to eq '204'
        end
      end
    end

  end
end
