class GithubUsernameValidator
  def self.check(username)
    response = HTTParty.get("https://api.github.com/users/#{username}")

    if response.code == 404
      raise "GitHub username '#{username}' not found"
    elsif response.code != 200
      raise "Failed to validate GitHub username (status code: #{response.code})"
    end
  end
end
