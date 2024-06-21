require 'rails_helper'

RSpec.describe Repository, type: :model do
  let(:user) { User.create!(username: "ValidUser") }
  subject { described_class.new(name: "ValidRepo", stars: 10, user: user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate name for the same user" do
      described_class.create!(name: "ValidRepo", stars: 10, user: user)
      expect(subject).to_not be_valid
    end

    it "is valid with a duplicate name for different users" do
      another_user = User.create!(username: "AnotherUser")
      described_class.create!(name: "ValidRepo", stars: 10, user: another_user)
      expect(subject).to be_valid
    end

    it "is valid with a name containing letters, numbers, underscores, and dashes" do
      subject.name = "Valid-Repo_123"
      expect(subject).to be_valid
    end

    it "is not valid with negative stars" do
      subject.stars = -1
      expect(subject).to_not be_valid
    end

    it "is valid with zero stars" do
      subject.stars = 0
      expect(subject).to be_valid
    end

    it "is not valid without a user" do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end
end
