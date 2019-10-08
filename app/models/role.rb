# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_type :string
#  resource_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Role < ApplicationRecord
  has_and_belongs_to_many :clients, join_table: :clients_roles

  belongs_to :resource,
             polymorphic: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
