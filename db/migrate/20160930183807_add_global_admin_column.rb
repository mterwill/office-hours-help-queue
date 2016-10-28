class AddGlobalAdminColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :global_admin, :boolean
  end
end
