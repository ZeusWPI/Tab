unless Rails.env.production?
  require 'factory_bot'
  require 'faker'
  task :sow => :environment do
    users = FactoryBot.create_list(:user, 20)
    100.times do
      sample_users = users.sample(2)
      FactoryBot.create :transaction, debtor: sample_users[0], creditor: sample_users[1]
    end
    clients = FactoryBot.create_list(:client, 5)
    100.times do
      debtor, creditor = users.sample(2)
      FactoryBot.create :client_transaction, issuer: clients.sample, debtor: debtor, creditor: creditor
    end
  end
end
