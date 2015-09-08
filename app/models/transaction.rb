class Transaction < ActiveRecord::Base
  belongs_to :debtor
  belongs_to :creditor
end
