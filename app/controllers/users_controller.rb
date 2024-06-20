class UsersController < ApplicationController
  def create
    username = params[:username]
    raise "Username can't be blank" if username.blank?
    raise "Invalid GitHub username format" unless username =~ /^[a-zA-Z0-9_-]+$/

    user = User.find_or_create_by(username: username)

    response = HTTParty.get("https://api.github.com/users/#{username}/repos")
    raise "Failed to fetch repositories from GitHub API (status code: #{response.code})" if response.code != 200

    repositories = JSON.parse(response.body)

    repositories.each do |repo_data|
      repo = user.repositories.find_or_initialize_by(name: repo_data['name'])
      repo.stars = repo_data['stargazers_count']
      repo.save!
    end

    render json: { message: 'User repositories have been fetched and stored.' }, status: :ok
  rescue StandardError => e
    Rails.logger.error("An error ocurred while fetching GitHub repositories for user #{username}: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
