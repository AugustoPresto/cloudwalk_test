require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe FetchGithubReposJob, type: :job do
  let(:user) { User.create!(username: 'valid-username') }
  let(:github_response) do
    [
      { 'name' => 'repo1', 'stargazers_count' => 10 },
      { 'name' => 'repo2', 'stargazers_count' => 5 }
    ]
  end

  before do
    allow(HTTParty).to receive(:get).and_return(double(code: 200, body: github_response.to_json))
  end

  describe '#perform' do
    context 'when user exists' do
      it 'fetches repositories from GitHub' do
        expect(HTTParty).to receive(:get).with("https://api.github.com/users/#{user.username}/repos")
        described_class.new.perform(user.username)
      end

      it 'updates user repositories' do
        described_class.new.perform(user.username)
        expect(user.repositories.count).to eq(2)
        expect(user.repositories.pluck(:name)).to contain_exactly('repo1', 'repo2')
        expect(user.repositories.find_by(name: 'repo1').stars).to eq(10)
        expect(user.repositories.find_by(name: 'repo2').stars).to eq(5)
      end

      it 'removes deleted repositories' do
        user.repositories.create!(name: 'repo1', stars: 0)
        user.repositories.create!(name: 'repo3', stars: 0)
        described_class.new.perform(user.username)
        expect(user.repositories.count).to eq(2)
        expect(user.repositories.pluck(:name)).to contain_exactly('repo1', 'repo2')
      end
    end

    context 'when user does not exist' do
      it 'does nothing' do
        expect { described_class.new.perform('nonexistent-username') }.not_to raise_error
      end
    end

    context 'when GitHub API returns an error' do
      before do
        allow(HTTParty).to receive(:get).and_return(double(code: 404, body: ''))
      end

      it 'raises an error' do
        expect { described_class.new.perform(user.username) }.to raise_error('Failed to fetch repositories from GitHub API (status code: 404)')
      end
    end

    context 'when unexpected error occurs' do
      before do
        allow(HTTParty).to receive(:get).and_raise(StandardError, 'Unexpected error')
      end

      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with("An error occurred while fetching GitHub repositories for user #{user.username}: Unexpected error")
        described_class.new.perform(user.username)
      end
    end
  end
end
