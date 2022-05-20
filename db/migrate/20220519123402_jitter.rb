class Jitter < ActiveRecord::Migration[5.2]
  def change
    add_column :course_queues, :add_requested_at_jitter, :boolean, null: false, default: false
  end
end
