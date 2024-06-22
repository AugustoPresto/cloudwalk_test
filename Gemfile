source "https://rubygems.org"

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'httparty', '~> 0.22.0' # HTTP resquests
gem 'sidekiq', '~> 7.2.4' # Background jobs
gem 'redis' # DB to store sidekiq jobs
gem 'rubocop', '~> 1.64', require: false # Check code good practices

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails', '~> 6.1.3' # Unit tests
  gem 'factory_bot_rails', '~> 6.4.3' # So we create fake models instances
  gem 'faker', '~> 3.4.1' # Use fake data
  gem 'dotenv-rails' # Saves environment variables on .env files
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.1.0' # Helps cleaning test database
  gem 'shoulda-matchers', '~> 6.2.0' # Provides RSpec matchers to test common functionalities
  gem 'vcr', '~> 6.2.0' # Records HTTP interactions
  gem 'webmock', '~> 3.23.1' # Stub HTTP requests in tests
  gem 'rspec-sidekiq' # Adds Sidekiq matchers
end
