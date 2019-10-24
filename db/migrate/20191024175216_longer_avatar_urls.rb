class LongerAvatarUrls < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :avatar_url, :string, :limit => 1000
  end
end
