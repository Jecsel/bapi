require 'sidekiq'
require 'sidekiq/web'
Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/#{ENV['REDIS_DB']}"}
end
    
Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{ENV['REDIS_URL']}:#{ENV['REDIS_PORT']}/#{ENV['REDIS_DB']}"}
end
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
end
schedule_file = "config/scheduler.yml" #Rails.root.join("config","scheduler.yml") #

if File.exist?(schedule_file) && Sidekiq.server?
    schedules = YAML.load_file(schedule_file)
    assign_schedules = schedules[ENV["APL_ENV"]] || schedules["INTERNAL"]
    Sidekiq::Cron::Job.load_from_hash assign_schedules
end