source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.6'
gem 'mysql2', '0.5.2'
gem 'oj', '3.3.8'
gem 'rake', '12.1.0'

gem 'dalli', '2.7.6'

gem 'sanitize', '4.5.0'
gem 'exception_notification', '4.2.2'
gem 'hkdf', '0.2.0'

gem 'aws-sdk-kms', '1.2.0'

gem 'http', '3.0.0'
gem 'sidekiq', '5.0.5'
gem 'listen', '3.1.5'

gem 'braintree', '~> 2.87'
gem 'safe_yaml', '0.6.3'

group :development, :test do
  # Use Puma as the app server
  gem 'puma', '3.11.4'

  gem 'pry'

  gem 'letter_opener'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  #gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]