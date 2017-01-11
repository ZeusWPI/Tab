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

require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
