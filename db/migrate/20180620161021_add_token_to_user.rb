class AddTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :key, :string

    User.all.each do |user|
      user.generate_key
      user.save
    end
  end
end
