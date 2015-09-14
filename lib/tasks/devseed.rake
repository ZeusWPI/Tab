unless Rails.env.production?
  require 'factory_girl'
  require 'faker'
  task :sow => :environment do
    users = FactoryGirl.create_list(:user, 20)
    100.times do
      sample_users = users.sample(2)
      FactoryGirl.create :transaction, debtor: sample_users[0], creditor: sample_users[1]
    end
    clients = FactoryGirl.create_list(:client, 5)
    100.times do
      debtor, creditor = users.sample(2)
      FactoryGirl.create :client_transaction, issuer: clients.sample, debtor: debtor, creditor: creditor
    end
  end
end
