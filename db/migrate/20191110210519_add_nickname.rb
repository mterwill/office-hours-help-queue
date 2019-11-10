class AddNickname < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nickname, :string
  end
end
