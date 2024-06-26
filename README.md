# Users GitHub Repositories Fetcher

This Ruby on Rails application allows users to input their GitHub username and fetches their public repositories. The fetched repository data is then saved into a PostgreSQL database. This application uses Sidekiq for background job processing to handle fetching repository data from the GitHub API.

## Features

- User creation with validation.
- Fetching and saving user repositories from GitHub.
- Background job processing using Sidekiq.
- Health check endpoint for monitoring.


## Production Link and Usage Examples

### Production Link
You can access the application in production at: [https://cloudwalk-test.osc-fr1.scalingo.io/](https://cloudwalk-test.osc-fr1.scalingo.io/)

### Usage Examples

#### Using Postman

1. Open Postman and set the request type to `POST`.
2. Set the request URL to `https://cloudwalk-test.osc-fr1.scalingo.io/users`.
3. Go to the "Params" tab.
4. Add a key `username` with the value being the GitHub username you want to fetch repositories for.
5. Click `Send` and check the response.

#### Using Insomnia

1. Open Insomnia and create a new `POST` request.
2. Set the request URL to `https://cloudwalk-test.osc-fr1.scalingo.io/users`.
3. Go to the "Query" tab.
4. In the request body, select `Form URL Encoded` and add a key `username` with the value being the GitHub username you want to fetch repositories for.
5. Click `Send` and check the response.

### Example Request

  ```
  curl -X POST https://cloudwalk-test.osc-fr1.scalingo.io/users -d "username=valid-github-username"
  ```

In all cases, you should see a JSON response like this if response code is 200:

  ```
  {
    "message": "User repositories fetched and saved."
  }
  ```

## Requirements for using locally

- Ruby 3.2.0
- Rails 7.1.3
- PostgreSQL
- Redis (for Sidekiq)
- Sidekiq

## Setup

### Prerequisites

Ensure you have the following installed:

- Ruby
- Rails
- PostgreSQL
- Redis

### Installation

1. **Clone the repository**

   ```
   git clone https://github.com/your-username/repo-name.git
   cd repo-name
   ```

2. **Install dependencies**

    ```
    bundle install
    ```

3. **Setup the database**

    ```
    rails db:create
    rails db:migrate
    ```

4. **Start Redis**

    Ensure Redis is running on your system. Check [Redis documentation](https://github.com/redis/redis-rb) to set up properly. You can start Redis using:

    ```
    redis-server
    ```

5. **Start Sidekiq**

    Remember to install [Sidekiq gem](https://github.com/sidekiq/sidekiq) correctly and start the Sidekiq worker.

    ```
    bundle exec sidekiq
    ```

6. **Start Rails server**

    ```
    rails s
    ```

### Environment Variables

Ensure you have the necessary environment variables set up in your application. You can use a `.env` file in the root of the app for local development:

  ```
  REDIS_URL=redis://localhost:6379/0
  ```


## Usage

### Create a User and Fetch Repositories

To create a user and fetch their repositories, make a POST request to the /users endpoint with the username parameter.

Example using `curl`:

  ```
  curl -X POST http://localhost:3000/users -d "username=githubusername"
  ```

Example using Postman:

1. Open Postman.
2. Create a new POST request.
3. Enter the request URL: http://localhost:3000/users.
4. Go to the "Params" tab.
5. Add a key `username` with the value of the GitHub username you want to fetch.
6. Click "Send".

Example using Insomnia:

1. Open Insomnia.
2. Create a new POST request.
3. Enter the request URL: http://localhost:3000/users.
4. Go to the "Query" tab.
5. Add a key `username` with the value of the GitHub username you want to fetch.
6. Click "Send".

In all cases, you should see a JSON response like this if response code is 200:

  ```
  {
	"message": "User repositories fetched and saved."
  }
  ```

### Monitor Sidekiq Jobs

You can monitor Sidekiq jobs by visiting the Sidekiq web interface at <http://localhost:3000/sidekiq>.

### Health Check

You can check the health of the application by visiting <http://localhost:3000/up>. This endpoint returns a 200 status code if the app is running properly.


## Database Schema

### Users Table
  | Column     | Type      |
  |------------|-----------|
  | id         | bigint    |
  | username   | string    |
  | created_at | datetime  |
  | updated_at | datetime  |

### Repositories Table
  | Column     | Type      |
  |------------|-----------|
  | id         | bigint    |
  | name       | string    |
  | stars      | integer   |
  | user_id    | bigint    |
  | created_at | datetime  |
  | updated_at | datetime  |


## Contributing
1. Fork the repository.
2. Create a new branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. Submit a pull request.


## Contact

For questions or issues, please open an issue on GitHub or contact [augustodesouzacardoso@gmail.com](mailto:augustodesouzacardoso@gmail.com).
