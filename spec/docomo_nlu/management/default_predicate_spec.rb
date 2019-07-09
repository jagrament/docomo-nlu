# frozen_string_literal: true

RSpec.describe DocomoNlu::Management::DefaultPredicate do
  before do
    DocomoNlu::Management::Base.access_token = DocomoNlu.config.admin_access_token
  end

  describe "#defaultPredicates" do
    let(:project_id) { 48 }
    let(:bot_id) { "test_bot" }

    it "Not found" do
      VCR.use_cassette("/management/default_predicate/index_not_found") do
        default_predicates = DocomoNlu::Management::DefaultPredicate.all(params: { project_id: project_id, bot_id: bot_id })
        expect(default_predicates).to eq []

        default_predicates = DocomoNlu::Management::DefaultPredicate.find(:all, params: { project_id: project_id, bot_id: bot_id })
        expect(default_predicates).to eq []

        default_predicates = DocomoNlu::Management::DefaultPredicate.where(project_id: project_id, bot_id: bot_id)
        expect(default_predicates).to eq []
      end
    end

    it "Create defaultPredicates" do
      default_predicate = DocomoNlu::Management::DefaultPredicate.new(color: "blue")
      default_predicate.prefix_options = { project_id: project_id, bot_id: bot_id }
      VCR.use_cassette("/management/default_predicate/create") do
        expect(default_predicate.save).to eq true
      end
    end

    it "Get defaultPredicates" do
      VCR.use_cassette("/management/default_predicate/index") do
        default_predicates = DocomoNlu::Management::DefaultPredicate.all(params: { project_id: project_id, bot_id: bot_id })
        expect(default_predicates.first.color).to eq "blue"

        default_predicates = DocomoNlu::Management::DefaultPredicate.find(:all, params: { project_id: project_id, bot_id: bot_id })
        expect(default_predicates.first.color).to eq "blue"

        default_predicates = DocomoNlu::Management::DefaultPredicate.where(project_id: project_id, bot_id: bot_id)
        expect(default_predicates.first.color).to eq "blue"
      end
    end

    it "Update defaultPredicates" do
      VCR.use_cassette("/management/default_predicate/index") do
        default_predicate = DocomoNlu::Management::DefaultPredicate.all(params: { project_id: project_id, bot_id: bot_id }).first
        VCR.use_cassette("/management/default_predicate/update") do
          default_predicate.color = "red"
          expect(default_predicate.save).to eq true
        end
      end
    end

    it "Delete defaultPredicates" do
      VCR.use_cassette("/management/default_predicate/index") do
        default_predicate = DocomoNlu::Management::DefaultPredicate.all(params: { project_id: project_id, bot_id: bot_id }).first
        VCR.use_cassette("/management/default_predicate/delete") do
          expect(default_predicate.destroy(["color"]).code).to eq "204"
        end
      end
    end
  end
end
