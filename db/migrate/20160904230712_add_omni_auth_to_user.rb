class AddOmniAuthToUser < ActiveRecord::Migration[5.0]
  def change
    add_column(:users, :uid, :string)
    add_column(:users, :oauth_token, :string)
    add_column(:users, :oauth_expires_at, :datetime)
  end
end
