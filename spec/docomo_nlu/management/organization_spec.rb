# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Organization do
  describe "#organizations" do
    ID = nil
    it "Get all organizations" do
      VCR.use_cassette("/management/organization/index") do
        organizations = DocomoNlu::Management::Organization.all
        expect(organizations.first.organizationId).not_to be_nil
      end
    end

    it "Create an organization" do
      VCR.use_cassette("/management/organization/create") do
        organization = DocomoNlu::Management::Organization.new(organizationName: "test_organization", address: "test_address", tel: "test_tel")
        expect(organization.save).to eq true
        ID = organization.id
      end
    end

    it "Get an organization" do
      VCR.use_cassette("/management/organization/show") do
        organization = DocomoNlu::Management::Organization.find(ID)
        expect(organization.id).to eq ID
      end
    end

    it "Update an organization" do
      VCR.use_cassette("/management/organization/show") do
        organization = DocomoNlu::Management::Organization.find(ID)
        VCR.use_cassette("/management/organization/update") do
          organization.organizationName = "update_organizationName"
          expect(organization.save).to eq true
        end
      end
    end

    it "Delete an organization" do
      VCR.use_cassette("/management/organization/show") do
        organization = DocomoNlu::Management::Organization.find(ID)
        VCR.use_cassette("/management/organization/delete") do
          expect(organization.destroy.code).to eq "204"
        end
      end
    end
  end
end
