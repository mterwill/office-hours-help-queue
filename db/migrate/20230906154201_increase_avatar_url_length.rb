class IncreaseAvatarUrlLength < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :avatar_url, :string, :limit => 5000
  end
end
