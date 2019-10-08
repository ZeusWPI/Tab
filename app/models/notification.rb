# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  message    :string
#  read       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  after_save :send_gcm_notification

  scope :unread, -> { where read: false }

  def read!
    update_attributes read: true
  end

  def create

  end

  def send_gcm_notification
      if !read
        begin
          if !Rpush::Gcm::App.find_by_name("tappb")
            app = Rpush::Gcm::App.new
            app.name = "tappb"
            app.auth_key = Rails.application.secrets.fcm_secret
            app.connections = 1
            app.save!
          end

          n = Rpush::Gcm::Notification.new
          n.app = Rpush::Gcm::App.find_by_name("tappb")
          n.registration_ids = user.android_device_registration_tokens.all.map{|r| r.token}
          n.data = { body: message, title: "Tabbp notification" }
          n.priority = 'high'
          n.content_available = true
          n.save!
        rescue
        end
      end


  end
end
