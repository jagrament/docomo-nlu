# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Organization do
  describe "#organizations" do
    it "Get all organizations" do
      VCR.use_cassette("/V26/organization/index") do
        organizations = DocomoNlu::Management::V26::Organization.all
        expect(organizations.first.organizationId).not_to be_nil
      end
    end

    it "Create an organization" do
      VCR.use_cassette("/V26/organization/create") do
        organization = DocomoNlu::Management::V26::Organization.new(organizationName: "test_organization", address: "test_address", tel: "test_tel")
        expect(organization.save).to eq true
      end
    end

    it "Get an organization" do
      VCR.use_cassette("/V26/organization/show") do
        organization = DocomoNlu::Management::V26::Organization.find(4)
        expect(organization.id).to eq 4
      end
    end

    it "Update an organization" do
      VCR.use_cassette("/V26/organization/show") do
        organization = DocomoNlu::Management::V26::Organization.find(4)
        VCR.use_cassette("/V26/organization/update") do
          organization.organizationName = "update_organizationName"
          expect(organization.save).to eq true
        end
      end
    end

    it "Delete an organization" do
      VCR.use_cassette("/V26/organization/show") do
        organization = DocomoNlu::Management::V26::Organization.find(4)
        VCR.use_cassette("/V26/organization/delete") do
          expect(organization.destroy.code).to eq "204"
        end
      end
    end
  end
end
