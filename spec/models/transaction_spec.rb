# frozen_string_literal: true

require "rails_helper"

# == Schema Information
#
# Table name: transactions
#
#  id           :integer          not null, primary key
#  debtor_id    :integer          not null
#  creditor_id  :integer          not null
#  issuer_id    :integer          not null
#  issuer_type  :string           not null
#  amount       :integer          default(0), not null
#  message      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  id_at_client :integer
#

RSpec.describe Transaction do
  it "has a valid factory" do
    expect(create(:transaction)).to be_valid
  end

  describe "cache" do
    let(:user) { create(:user) }

    it "updates creditor cache" do
      trans = build(:transaction, creditor: user, amount: 10)
      expect { trans.save! }.to change(user, :balance).by(10)
    end

    it "updates debtor cache" do
      trans = build(:transaction, debtor: user, amount: 10)
      expect { trans.save! }.to change(user, :balance).by(-10)
    end
  end

  describe "amount" do
    it "is positive" do
      expect(build(:transaction, amount: -5)).not_to be_valid
    end

    it "is greater than be 0" do
      expect(build(:transaction, amount: 0)).not_to be_valid
    end
  end

  describe "debtor/creditor" do
    let(:user) { create(:user) }

    it "is different" do
      expect(build(:transaction, debtor: user, creditor: user)).not_to be_valid
    end
  end

  describe "client as issuer" do
    let(:transaction) { create(:client_transaction) }

    it "has a id_at_client" do
      transaction.id_at_client = nil
      expect(transaction).not_to be_valid
    end

    it "has a unique id_at_client" do
      t = build(:client_transaction, issuer: transaction.issuer, id_at_client: transaction.id_at_client)
      expect(t).not_to be_valid
    end

    it "has a unique id_at_client per client" do
      t = build(:client_transaction, id_at_client: transaction.id_at_client)
      expect(t).to be_valid
    end
  end
end
