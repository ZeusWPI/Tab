class Notification < ActiveRecord::Base
  belongs_to :user

  def read!
    update_attributes read: true
  end
end
