# frozen_string_literal: true

class AndroidDeviceRegistrationToken < ApplicationRecord
	belongs_to :user
end
