class AddGroupExclusive < ActiveRecord::Migration[5.0]
  def change
    add_column :course_queues, :exclusive, :boolean, null: false, default: false
  end
end
