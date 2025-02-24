if ENV["RAILS_ENV"] != "test"
  Sidekiq::Cron.configure do |_config|
    # config.natural_cron_parsing_mode = :single

    Sidekiq::Cron::Job.create(name: "Monthly Reminder", cron: "0 0 1 * *", class: "MonthlyReminder")
  end
end
