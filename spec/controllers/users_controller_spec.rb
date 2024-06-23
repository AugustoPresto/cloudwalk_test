require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:valid_username) { 'valid-username' }
    let(:invalid_username_format) { 'invalid username' }
    let(:nonexistent_username) { 'nonexistent-username' }

    before do
      allow(FetchGithubReposJob).to receive(:perform_async)
      allow(HTTParty).to receive(:get).and_return(double('response', code: 200))
    end

    context 'with valid username' do
      before do
        allow(HTTParty).to receive(:get).with("https://api.github.com/users/#{valid_username}").and_return(double('response', code: 200))
      end

      it 'creates a user if it does not exist' do
        expect {
          post :create, params: { username: valid_username }
        }.to change(User, :count).by(1)
      end

      it 'does not create a user if it already exists' do
        User.create!(username: valid_username)
        expect {
          post :create, params: { username: valid_username }
        }.not_to change(User, :count)
      end

      it 'queues a job to fetch GitHub repositories' do
        post :create, params: { username: valid_username }
        expect(FetchGithubReposJob).to have_received(:perform_async).with(valid_username)
      end

      it 'returns a success message' do
        post :create, params: { username: valid_username }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('User repositories fetched and saved.')
      end
    end

    context 'with invalid username format' do
      it 'raises an error if username is blank' do
        post :create, params: { username: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Username can't be blank")
      end

      it 'raises an error if username format is invalid' do
        post :create, params: { username: invalid_username_format }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid GitHub username format')
      end
    end

    context 'when GitHub username does not exist' do
      before do
        allow(HTTParty).to receive(:get).with("https://api.github.com/users/#{nonexistent_username}").and_return(double('response', code: 404))
      end

      it 'raises an error if GitHub username is not found' do
        post :create, params: { username: nonexistent_username }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("GitHub username '#{nonexistent_username}' not found")
      end
    end

    context 'with unexpected error' do
      before do
        allow(HTTParty).to receive(:get).with("https://api.github.com/users/#{valid_username}").and_return(double('response', code: 200))
      end

      it 'handles unexpected errors gracefully' do
        allow(User).to receive(:find_or_create_by!).and_raise(StandardError, 'Unexpected error')
        post :create, params: { username: valid_username }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Unexpected error')
      end
    end
  end
end
