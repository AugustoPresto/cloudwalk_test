class UsersController < ApplicationController
  def create
    username = params[:username]
    user = User.find_or_create_by(username: username)

    response = HTTParty.get("https://api.github.com/users/#{username}/repos")
    repositories = JSON.parse(response.body)

    repositories.each do |repo|
      user.repositories.find_or_create_by(
        name: repo['name'],
        stars: repo['stargazers_count']
      )
    end
  end
end
