# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V26::Map do
  before do
    DocomoNlu::Management::V26::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#maps" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    context "Invalid File Upload" do
      it "Use class method create()" do
        VCR.use_cassette("/V26/map/create_400") do
          file = File.new(File.join("spec", "fixtures", "management", "error.map"))
          prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { DocomoNlu::Management::V26::Map.create(file, prefix_options) }.to raise_error(ActiveResource::BadRequest)
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/V26/map/save_400") do
          map = DocomoNlu::Management::V26::Map.new
          map.file = File.new(File.join("spec", "fixtures", "management", "error.map"))
          map.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { map.save }.to raise_error(ActiveResource::BadRequest)
        end
      end
    end

    context "Download zip" do
      it "Use all" do
        VCR.use_cassette("/V26/map/index_all") do
          map = DocomoNlu::Management::V26::Map.all(params: { project_id: project_id, bot_id: bot_id })
          expect(map.file.size).not_to be 0
        end
      end
      it "Use find" do
        VCR.use_cassette("/V26/map/index_find") do
          map = DocomoNlu::Management::V26::Map.find(nil, params: { project_id: project_id, bot_id: bot_id })
          expect(map.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/V26/map/index_where") do
          map = DocomoNlu::Management::V26::Map.where(project_id: project_id, bot_id: bot_id)
          expect(map.file.size).not_to be 0
        end
      end
    end

    context "Upload map" do
      it "Use class method create()" do
        VCR.use_cassette("/V26/map/create") do
          res = DocomoNlu::Management::V26::Map.create(File.new(File.join("spec", "fixtures", "management", "test.map")), project_id: project_id, bot_id: bot_id)
          expect(res).to be_truthy
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/V26/map/save") do
          map = DocomoNlu::Management::V26::Map.new
          map.file = File.new(File.join("spec", "fixtures", "management", "test.map"))
          map.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect(map.save).to be_truthy
        end
      end
    end

    context "Download map" do
      it "Use find" do
        VCR.use_cassette("/V26/map/show_find") do
          map = DocomoNlu::Management::V26::Map.find("test", params: { project_id: project_id, bot_id: bot_id })
          expect(map.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/V26/map/show_where") do
          map = DocomoNlu::Management::V26::Map.where(category: "test", project_id: project_id, bot_id: bot_id)
          expect(map.file.size).not_to be 0
        end
      end
    end

    context "Delete map" do
      it "use destroy" do
        VCR.use_cassette("/V26/map/show_find") do
          map = DocomoNlu::Management::V26::Map.find("test", params: { project_id: project_id, bot_id: bot_id })
          VCR.use_cassette("/V26/map/delete") do
            expect(map.destroy.code).to eq "204"
          end
        end
      end
    end
  end
end
