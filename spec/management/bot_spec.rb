RSpec.describe DocomoNlu::Management::Bot do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end
  describe '#bots' do
    it 'bots not found' do
      VCR.use_cassette('/bot/index_not_found') do
        bots = DocomoNlu::Management::Bot.all(params: {project_id: 212})
        expect(bots).to eq []
      end
    end

    it 'Create a bot' do
      VCR.use_cassette('/bot/create') do
        bot = DocomoNlu::Management::Bot.new({ botId: 'test_bot',scenarioProjectId: 'DSU', language: 'ja-JP', description: 'for test'})
        bot.prefix_options['project_id'] = 212
        expect(bot.save).to eq true
      end
    end

    it 'Get all bots' do
      VCR.use_cassette('/bot/index') do
        bots = DocomoNlu::Management::Bot.all(params: {project_id: 212})
        expect(bots.first.botId).not_to be_nil
      end
    end

    it 'Conflict bot Id' do
      VCR.use_cassette('/bot/create_conflict') do
        bot = DocomoNlu::Management::Bot.new({ botId: 'test_bot',scenarioProjectId: 'DSU', language: 'ja-JP', description: 'for test'})
        bot.prefix_options['project_id'] = 212
        expect{bot.save}.to raise_error(ActiveResource::ResourceConflict)
      end
    end

    it 'Get an bot' do
      VCR.use_cassette('/bot/show') do
        bot = DocomoNlu::Management::Bot.find('test_bot',params: {project_id: 212})
        expect(bot.id).to eq 'test_bot'
      end
    end

    it 'Delete an bot' do
      VCR.use_cassette('/bot/show') do
        bot = DocomoNlu::Management::Bot.find('test_bot',params: {project_id: 212})
        VCR.use_cassette('/bot/delete') do
          expect(bot.destroy.code).to eq '204'
        end
      end
    end
  end
end
