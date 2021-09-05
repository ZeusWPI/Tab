# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

if Rails.env.development?

  hupseflupse = User.create name: 'hupseflupse'

  others = 100.times.map do |i|
    User.create name: "user#{i}"
  end


  10.times do
    others.each do |other|
      Transaction.create message: 'ping', amount: 100, debtor: hupseflupse, creditor: other, issuer: other
      Transaction.create message: 'pong', amount: 100, debtor: other, creditor: hupseflupse, issuer: hupseflupse
    end
  end
end
