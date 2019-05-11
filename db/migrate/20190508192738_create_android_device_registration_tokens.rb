class CreateAndroidDeviceRegistrationTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :android_device_registration_tokens do |t|
      t.string :token
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
