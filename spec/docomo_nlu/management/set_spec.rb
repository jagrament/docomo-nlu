# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Set do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#sets" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    context "Invalid File Upload" do
      it "Use class method create()" do
        VCR.use_cassette("/management/set/create_400") do
          file = File.new(File.join("spec", "fixtures", "management", "error.set"))
          prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { described_class.create(file, prefix_options) }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/management/set/save_400") do
          set = described_class.new
          set.file = File.new(File.join("spec", "fixtures", "management", "error.set"))
          set.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { set.save }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
    end

    context "Download zip" do
      it "Use all" do
        VCR.use_cassette("/management/set/index_all") do
          set = described_class.all(params: { project_id: project_id, bot_id: bot_id })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use find" do
        VCR.use_cassette("/management/set/index_find") do
          set = described_class.find(nil, params: { project_id: project_id, bot_id: bot_id })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/management/set/index_where") do
          set = described_class.where(project_id: project_id, bot_id: bot_id)
          expect(set.file.size).not_to be 0
        end
      end
    end

    context "Upload set" do
      it "Use class method create()" do
        VCR.use_cassette("/management/set/create") do
          attributes = { project_id: project_id, bot_id: bot_id }
          res = described_class.create(File.new(File.join("spec", "fixtures", "management", "test.set")), attributes)
          expect(res).to be_truthy
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/management/set/save") do
          set = described_class.new
          set.file = File.new(File.join("spec", "fixtures", "management", "test.set"))
          set.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect(set.save).to be_truthy
        end
      end
    end

    context "Download set" do
      it "Use find" do
        VCR.use_cassette("/management/set/show_find") do
          set = described_class.find("test", params: { project_id: project_id, bot_id: bot_id })
          expect(set.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/management/set/show_where") do
          set = described_class.where(category: "test", project_id: project_id, bot_id: bot_id)
          expect(set.file.size).not_to be 0
        end
      end
    end

    context "Delete set" do
      it "use destroy" do
        VCR.use_cassette("/management/set/show_find") do
          set = described_class.find("test", params: { project_id: project_id, bot_id: bot_id })
          VCR.use_cassette("/management/set/delete") do
            expect(set.destroy.code).to eq "204"
          end
        end
      end
    end
  end
end
