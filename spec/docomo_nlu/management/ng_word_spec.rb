# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::NGWord do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#ng_word" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    context "Invalid File Upload" do
      it "Use class method create()" do
        VCR.use_cassette("/management/ng_word/create_400") do
          file = File.new(File.join("spec", "fixtures", "management", "error.zip"))
          prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { described_class.create(file, prefix_options) }.to raise_error(ActiveResource::BadRequest)
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/management/ng_word/save_400") do
          ng = described_class.new
          ng.file = File.new(File.join("spec", "fixtures", "management", "error.zip"))
          ng.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { ng.save }.to raise_error(ActiveResource::BadRequest)
        end
      end
    end

    context "Resource Conflict" do
      it "Use class method create()" do
        VCR.use_cassette("/management/ng_word/create_409") do
          file = File.new(File.join("spec", "fixtures", "management", "error.ng"))
          prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { described_class.create(file, prefix_options) }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/management/ng_word/save_409") do
          ng = described_class.new
          ng.file = File.new(File.join("spec", "fixtures", "management", "error.ng"))
          ng.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect { ng.save }.to raise_error(ActiveResource::ResourceConflict)
        end
      end
    end

    context "Download .ng" do
      it "Use all" do
        VCR.use_cassette("/management/ng_word/index_all") do
          ng = described_class.all(params: { project_id: project_id, bot_id: bot_id })
          expect(ng.file.size).not_to be 0
        end
      end
      it "Use find" do
        VCR.use_cassette("/management/ng_word/index_find") do
          ng = described_class.find(params: { project_id: project_id, bot_id: bot_id })
          expect(ng.file.size).not_to be 0
        end
      end
      it "Use where" do
        VCR.use_cassette("/management/ng_word/index_where") do
          ng = described_class.where(project_id: project_id, bot_id: bot_id)
          expect(ng.file.size).not_to be 0
        end
      end
    end

    context "Upload NG file" do
      it "Use class method create()" do
        VCR.use_cassette("/management/ng_word/create") do
          attributes = { project_id: project_id, bot_id: bot_id }
          res = described_class.create(File.new(File.join("spec", "fixtures", "management", "test.ng")), attributes)
          expect(res).to be_truthy
        end
      end
      it "Use instance method save()" do
        VCR.use_cassette("/management/ng_word/save") do
          ng = described_class.new
          ng.file = File.new(File.join("spec", "fixtures", "management", "test.ng"))
          ng.prefix_options = { project_id: project_id, bot_id: bot_id }
          expect(ng.save).to be_truthy
        end
      end
    end

    context "Delete ng" do
      it "use destroy" do
        VCR.use_cassette("/management/ng_word/show_find") do
          ng = described_class.find(params: { project_id: project_id, bot_id: bot_id })
          VCR.use_cassette("/management/ng_word/delete") do
            expect(ng.destroy.code).to eq "204"
          end
        end
      end
    end
  end
end
