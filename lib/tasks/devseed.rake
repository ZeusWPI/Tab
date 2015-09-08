require 'factory_girl'

task :sow => :environment do
  users = FactoryGirl.create_list(:user, 20)
  100.times do
    FactoryGirl.create :transaction, debtor: users.sample, creditor: users.sample
  end
end

