class FetchGithubReposJob
  include Sidekiq::Job
  sidekiq_options queue: 'default', retry: 5

  def perform(username)
    user = User.find_by(username: username)
    return unless user

    response = HTTParty.get("https://api.github.com/users/#{username}/repos")
    raise "Failed to fetch repositories from GitHub API (status code: #{response.code})" if response.code != 200

    repositories = JSON.parse(response.body)

    repositories.each do |repo_data|
      repo = user.repositories.find_or_initialize_by(name: repo_data['name'])
      repo.stars = repo_data['stargazers_count']
      repo.save!
    end

  rescue StandardError => e
    Rails.logger.error("An error ocurred while fetching GitHub repositories for user #{username}: #{e.message}")
  end
end
