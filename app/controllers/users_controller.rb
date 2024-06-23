class UsersController < ApplicationController
  def create
    username = params[:username].strip
    # First, validate username name spelling.
    # Then, check if it exists in GitHub.
    validate_username_format(username)
    check_github_username_exists(username)

    # If the user exists in the DB, find it and update the repos.
    # If it doesn't, create it and it's repos.
    user = User.find_or_create_by!(username: username)
    FetchGithubReposJob.perform_async(user.username)

    render json: { message: 'User repositories fetched and saved.' }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Error creating user #{username}: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def validate_username_format(username)
    raise "Username can't be blank" if username.blank?
    raise 'Invalid GitHub username format' unless username =~ /\A[-a-zA-Z0-9][a-zA-Z0-9_-]*\z/
  end

  def check_github_username_exists(username)
    response = HTTParty.get("https://api.github.com/users/#{username}")

    if response.code == 404
      raise "GitHub username '#{username}' not found"
    elsif response.code != 200
      raise "Failed to validate GitHub username (status code: #{response.code})"
    end
  end
end
