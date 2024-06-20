require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'POST /users' do
    context 'with valid username' do
      it "creates a user and triggers the background job" do
        expect {
          post users_path, params: { username: 'octocat' }
        }.to change(User, :count).by(1)

        expect(FetchGithubReposJob).to have_enqueued_sidekiq_job('octocat')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with blank username' do
      it 'raises an error' do
        post '/users', params: { username: '' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Username can't be blank")
      end
    end

    context 'with invalid GitHub username format' do
      it 'raises an error' do
        post '/users', params: { username: 'invalid_username!' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid GitHub username format')
      end
    end

    context 'when user creation fails' do
      it 'logs an error and raises an error' do
        allow(User).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordInvalid.new(User.new))
        expect(Rails.logger).to receive(:error)

        post '/users', params: { username: 'valid_username' }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
