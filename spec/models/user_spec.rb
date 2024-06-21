require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(username: "ValidUsername") }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a username" do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a blank string" do
      subject.username = ""
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate username" do
      described_class.create!(username: "ValidUsername")
      expect(subject).to_not be_valid
    end

    it "is not valid with a username longer than 39 characters" do
      subject.username = "a" * 40
      expect(subject).to_not be_valid
    end

    it "is valid with a username starting with a dash" do
      subject.username = "-ValidUsername"
      expect(subject).to be_valid
    end

    it "is valid with a username containing letters, numbers, underscores, and dashes" do
      subject.username = "Valid-Username_123"
      expect(subject).to be_valid
    end

    it "is not valid with a username containing invalid characters" do
      subject.username = "Invalid@Username"
      expect(subject).to_not be_valid
    end
  end
end
