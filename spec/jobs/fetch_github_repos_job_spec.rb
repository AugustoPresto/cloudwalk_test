require 'rails_helper'
require 'sidekiq/testing'
require 'vcr'

RSpec.describe FetchGithubReposJob, type: :job do
  let(:user) { User.create!(username: 'AugustoPresto') }

  describe '#perform', :vcr do
    context 'when user exists' do
      it 'fetches repositories from GitHub' do
        VCR.use_cassette('github_fetch_repos') do
          described_class.new.perform(user.username)
        end
        expect(user.repositories.count).to be > 0
      end

      it 'updates user repositories' do
        VCR.use_cassette('github_fetch_repos') do
          described_class.new.perform(user.username)
        end
        repo = user.repositories.find_by(name: 'cloudwalk_test')
        expect(repo).to be_present
        expect(repo.stars).to be > 0
      end

      it 'removes deleted repositories' do
        user.repositories.create!(name: 'repo1', stars: 0)
        user.repositories.create!(name: 'repo3', stars: 0)
        VCR.use_cassette('github_fetch_repos') do
          described_class.new.perform(user.username)
        end
        expect(user.repositories.where(name: 'repo3')).to be_empty
      end
    end

    context 'when unexpected error occurs' do
      it 'logs the error' do
        allow(HTTParty).to receive(:get).and_raise(StandardError, 'Unexpected error')
        expect(Rails.logger).to receive(:error).with("An error occurred while fetching GitHub repositories for user #{user.username}: Unexpected error")
        described_class.new.perform(user.username)
      end
    end

    context 'when a timeout error occurs' do
      it 'logs the timeout error' do
        allow(HTTParty).to receive(:get).and_raise(Net::ReadTimeout)
        expect(Rails.logger).to receive(:error).with("An error occurred while fetching GitHub repositories for user #{user.username}: Net::ReadTimeout")
        described_class.new.perform(user.username)
      end
    end

    context 'when JSON parsing error occurs' do
      it 'logs the JSON parsing error' do
        allow(HTTParty).to receive(:get).and_return(double(code: 200, body: 'invalid json'))
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError, 'unexpected token')
        expect(Rails.logger).to receive(:error).with("An error occurred while fetching GitHub repositories for user #{user.username}: unexpected token")
        described_class.new.perform(user.username)
      end
    end
  end
end
