# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Organization do
  describe "#organizations" do
    it "Get all organizations" do
      VCR.use_cassette("/V23/organization/index") do
        organizations = DocomoNlu::Management::V23::Organization.all
        expect(organizations.first.organizationId).not_to be_nil
      end
    end

    it "Create an organization" do
      VCR.use_cassette("/V23/organization/create") do
        organization = DocomoNlu::Management::V23::Organization.new(organizationName: "test_organization1", address: "test_address", tel: "test_tel")
        expect(organization.save).to eq true
      end
    end

    it "Get an organization" do
      VCR.use_cassette("/V23/organization/show") do
        organization = DocomoNlu::Management::V23::Organization.find(597)
        expect(organization.id).to eq 597
      end
    end

    it "Update an organization" do
      VCR.use_cassette("/V23/organization/show") do
        organization = DocomoNlu::Management::V23::Organization.find(597)
        VCR.use_cassette("/V23/organization/update") do
          organization.organizationName = "update_organizationName1"
          expect(organization.save).to eq true
        end
      end
    end

    it "Delete an organization" do
      VCR.use_cassette("/V23/organization/show") do
        organization = DocomoNlu::Management::V23::Organization.find(597)
        VCR.use_cassette("/V23/organization/delete") do
          expect(organization.destroy.code).to eq "204"
        end
      end
    end
  end
end
