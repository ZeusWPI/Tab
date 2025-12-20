# frozen_string_literal: true

require "rails_helper"

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  balance    :integer          default(0), not null
#  penning    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

RSpec.describe User do
  let(:user) { create(:user) }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  it "has a unique name" do
    new_user = build(:user, name: user.name)
    expect(new_user).not_to be_valid
  end
end
