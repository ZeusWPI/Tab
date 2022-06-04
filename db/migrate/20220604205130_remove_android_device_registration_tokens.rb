class RemoveAndroidDeviceRegistrationTokens < ActiveRecord::Migration[7.0]
  def change
    drop_table :android_device_registration_tokens
  end
end
