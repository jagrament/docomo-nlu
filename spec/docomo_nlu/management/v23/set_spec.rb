# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::V23::Set do
  before do
    DocomoNlu::Management::V23::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#sets" do
    context "Invalid File Upload" do
      it "Use class method create()" do
        VCR.use_cassette("/V23/set/create_400") do
          file = File.new(File.join("spec", "fixtures", "management", "error.set"))
          prefix_options = { project_id: 212, bot_id: "test_bot" }
          expect { DocomoNlu::Management::V23::Set.create(file, prefix_options) }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/V23/set/save_400") do
          set = DocomoNlu::Management::V23::Set.new
          set.file = File.new(File.join("spec", "fixtures", "management", "error.set"))
          set.prefix_options = { project_id: 212, bot_id: "test_bot" }
          expect { set.save }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
    end

    context "Download zip" do
      it "Use all" do
        VCR.use_cassette("/V23/set/index_all") do
          set = DocomoNlu::Management::V23::Set.all(params: { project_id: 212, bot_id: "test_bot" })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use find" do
        VCR.use_cassette("/V23/set/index_find") do
          set = DocomoNlu::Management::V23::Set.find(nil, params: { project_id: 212, bot_id: "test_bot" })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/V23/set/index_where") do
          set = DocomoNlu::Management::V23::Set.where(project_id: 212, bot_id: "test_bot")
          expect(set.file.size).not_to be 0
        end
      end
    end

    context "Upload set" do
      it "Use class method create()" do
        VCR.use_cassette("/V23/set/create") do
          res = DocomoNlu::Management::V23::Set.create(File.new(File.join("spec", "fixtures", "management", "test.set")), project_id: 212, bot_id: "test_bot")
          expect(res).to be_truthy
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/V23/set/save") do
          set = DocomoNlu::Management::V23::Set.new
          set.file = File.new(File.join("spec", "fixtures", "management", "test.set"))
          set.prefix_options = { project_id: 212, bot_id: "test_bot" }
          expect(set.save).to be_truthy
        end
      end
    end

    context "Download set" do
      it "Use find" do
        VCR.use_cassette("/V23/set/show_find") do
          set = DocomoNlu::Management::V23::Set.find("test", params: { project_id: 212, bot_id: "test_bot" })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/V23/set/show_where") do
          set = DocomoNlu::Management::V23::Set.where(category: "test", project_id: 212, bot_id: "test_bot")
          expect(set.file.size).not_to be 0
        end
      end
    end

    context "Delete set" do
      it "use destroy" do
        VCR.use_cassette("/V23/set/show_find") do
          set = DocomoNlu::Management::V23::Set.find("test", params: { project_id: 212, bot_id: "test_bot" })
          VCR.use_cassette("/V23/set/delete") do
            expect(set.destroy.code).to eq "204"
          end
        end
      end
    end
  end
end
