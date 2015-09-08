require 'factory_girl'
require 'faker'

task :sow => :environment do
  users = FactoryGirl.create_list(:user, 20)
  100.times do
    sample_users = users.sample(2)
    FactoryGirl.create :transaction, debtor: sample_users[0], creditor: sample_users[1], amount: 1 + rand(100)
  end
end

