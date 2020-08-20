source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'mysql2'
gem 'puma', '~> 4.1'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-cors'
gem 'kaminari'
gem 'jwt'
gem 'search_cop'
gem 'sidekiq'
gem "aws-sdk-s3", require: false
gem 'roo'
gem 'prawn'
gem 'prawn-templates', '~> 0.1.2'
gem 'barby'
gem 'chunky_png', '~> 1.3', '>= 1.3.5'
gem "sentry-raven"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
if Gem.win_platform?
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
end
