# frozen_string_literal: true

require "rails_helper"

# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  key        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

RSpec.describe Client do
  let(:client) { create(:client) }

  it "has a valid factory" do
    expect(client).to be_valid
  end

  it "generates a key" do
    expect(client.key).to be_present
  end

  it "has a unique name" do
    new_client = build(:client, name: client.name)
    expect(new_client).not_to be_valid
  end
end
