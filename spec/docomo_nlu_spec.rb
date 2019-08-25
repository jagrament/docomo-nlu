# frozen_string_literal: true

RSpec.describe DocomoNlu do
  it "has a version number" do
    expect(DocomoNlu::VERSION).not_to be nil
  end

  it "Successfully loading DoomoNlu" do
    expect(described_class).not_to be nil
  end

  it "Successfully loading DoomoNlu::Management::Base" do
    expect(DocomoNlu::Management::Base).not_to be nil
  end

  it "Successfully loading DoomoNlu::Management::Account" do
    expect(DocomoNlu::Management::Account).not_to be nil
  end

  it "Successfully loading DoomoNlu::Spontaneous" do
    expect(DocomoNlu::Spontaneous).not_to be nil
  end
end
