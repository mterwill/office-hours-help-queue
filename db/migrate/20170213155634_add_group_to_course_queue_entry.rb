class AddGroupToCourseQueueEntry < ActiveRecord::Migration[5.0]
  def change
    add_column :course_queue_entries, :course_group_id, :integer
  end
end
