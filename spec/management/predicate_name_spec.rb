RSpec.describe DocomoNlu::Management::PredicateName do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe '#predicateName' do
    context 'Create predicate name' do
      it 'Use save()' do
        VCR.use_cassette('predicate_name/create') do
          predicate_name = DocomoNlu::Management::PredicateName.new
          predicate_name.prefix_options = { project_id: 212, bot_id: 'test_bot' }
          predicate_name.predicateNames = ['color']
          expect(predicate_name.save).to eq true
        end
      end
    end

    context 'Get predicate_names' do
      it 'Use all()' do
        VCR.use_cassette('predicate_name/index_all') do
          predicate_names = DocomoNlu::Management::PredicateName.all(params: { project_id: 212, bot_id: 'test_bot' })
          expect(predicate_names.first.params).not_to be nil
        end
      end
      it 'Use find()' do
        VCR.use_cassette('predicate_name/index_find') do
          predicate_names = DocomoNlu::Management::PredicateName.find(:all,params: { project_id: 212, bot_id: 'test_bot' })
          expect(predicate_names.first.params).not_to be nil
        end
      end
      it 'User where()' do
        VCR.use_cassette('predicate_name/index_where') do
          predicate_names = DocomoNlu::Management::PredicateName.where({ project_id: 212, bot_id: 'test_bot' })
          expect(predicate_names.first.params).not_to be nil
        end
      end
    end

    context 'Delete  predicate_names' do
      it 'Use destroy(keys)' do
        VCR.use_cassette('predicate_name/index') do
          predicate_name = DocomoNlu::Management::PredicateName.all(params: { project_id: 212, bot_id: 'test_bot' }).first
          VCR.use_cassette('predicate_name/delete') do
            expect(predicate_name.destroy(['color']).code).to eq '204'
          end
        end
      end
    end
  end
end
