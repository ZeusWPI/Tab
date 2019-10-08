# == Schema Information
#
# Table name: android_device_registration_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AndroidDeviceRegistrationToken, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
