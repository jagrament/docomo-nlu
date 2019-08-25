# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::Bot do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#bots" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    it "bots not found" do
      VCR.use_cassette("/management/bot/index_not_found") do
        bots = described_class.all(params: { project_id: project_id })
        expect(bots).to eq []
      end
    end

    it "Create a bot" do
      VCR.use_cassette("/management/bot/create") do
        bot = described_class.new(botId: bot_id, scenarioProjectId: "DSU", language: "ja-JP", description: "for test")
        bot.prefix_options["project_id"] = project_id
        expect(bot.save).to eq true
      end
    end

    it "Get all bots" do
      VCR.use_cassette("/management/bot/index") do
        bots = described_class.all(params: { project_id: project_id })
        expect(bots.first.botId).not_to be_nil
      end
    end

    it "Conflict bot Id" do
      VCR.use_cassette("/management/bot/create_conflict") do
        bot = described_class.new(botId: bot_id, scenarioProjectId: "DSU", language: "ja-JP", description: "for test")
        bot.prefix_options["project_id"] = project_id
        expect { bot.save }.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it "Get an bot" do
      VCR.use_cassette("/management/bot/show") do
        bot = described_class.find(bot_id, params: { project_id: project_id })
        expect(bot.id).to eq bot_id
      end
    end

    describe "#aiml" do
      context "Upload file" do
        it "Upload AIML" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_aiml") do
              bot.prefix_options[:method] = :aiml
              response = bot.upload(stub_file("test.aiml"))
              expect(response).to eq true
            end
          end
        end

        it "Upload dat" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_dat") do
              bot.prefix_options[:method] = :dat
              response = bot.upload(stub_file("test.dat"))
              expect(response).to eq true
            end
          end
        end

        it "Upload zip" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_archive") do
              bot.prefix_options[:method] = :archive
              response = bot.upload(stub_file("test.zip"))
              expect(response).to eq true
            end
          end
        end
      end

      context "Deploy bot" do
        it "Use deppoy()" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/deploy") do
              expect(bot.deploy).to eq true
            end
          end
        end
      end

      context "Download file using instance" do
        it "Download AIML" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/download_aiml") do
              bot.prefix_options[:method] = :aiml
              bot.download("test")
              expect(bot.file).not_to be_nil
            end
          end
        end

        it "Download dat" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/download_dat") do
              bot.prefix_options[:method] = :dat
              bot.download
              expect(bot.file).not_to be_nil
            end
          end
        end

        it "Download zip" do
          VCR.use_cassette("/management/bot/show") do
            bot = described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/download_archive") do
              bot.prefix_options[:method] = :archive
              bot.download
              expect(bot.file).not_to be_nil
            end
          end
        end
      end
    end

    describe "#FAQ" do
      context "userDic" do
        it "Upload" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_userDic") do
            end
          end
        end
        it "Status" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/status_userDic") do
            end
          end
        end
      end

      context "stopkey" do
        it "Upload" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_stopkey") do
            end
          end
        end
        it "Download" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/download_stopkey") do
            end
          end
        end
        it "Status" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/status_stopkey") do
            end
          end
        end
      end

      context "truthlist" do
        it "Upload" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_truthlist") do
            end
          end
        end
        it "Download" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/download_truthlist") do
            end
          end
        end
        it "Status" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/status_truthlist") do
            end
          end
        end
      end

      context "entry" do
        it "Upload" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/upload_entry") do
            end
          end
        end
        it "Status" do
          VCR.use_cassette("/management/bot/show") do
            described_class.find(bot_id, params: { project_id: project_id })
            VCR.use_cassette("/management/bot/status_entry") do
            end
          end
        end
      end
    end

    it "Delete an bot" do
      VCR.use_cassette("/management/bot/show") do
        bot = described_class.find(bot_id, params: { project_id: project_id })
        VCR.use_cassette("/management/bot/delete") do
          expect(bot.destroy.code).to eq "204"
        end
      end
    end
  end
end
