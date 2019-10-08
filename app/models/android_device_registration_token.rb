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

class AndroidDeviceRegistrationToken < ApplicationRecord
  belongs_to :user
end
