class UsersController < ApplicationController
  def create
    username = params[:username].strip
    raise "Username can't be blank" if username.blank?
    raise "Invalid GitHub username format" unless username =~ /^[a-zA-Z0-9_-]+$/

    user = User.find_or_create_by!(username: username)
    FetchGithubReposJob.perform_async(user.username)

    render json: { message: 'User repositories fetched and saved.' }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Error creating user #{username}: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
