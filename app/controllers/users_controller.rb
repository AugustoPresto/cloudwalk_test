class UsersController < ApplicationController
  def create
    username = params[:username]
    user = User.find_or_create_by(username: username)

    response = HTTParty.get("https://api.github.com/users/#{username}/repos")
    repositories = JSON.parse(response.body)

    repositories.each do |repo_data|
      repo = user.repositories.find_or_initialize_by(name: repo_data['name'])
      repo.stars = repo_data['stargazers_count']
      repo.save!
    end

    render json: { message: 'User repositories have been fetched and stored.' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
