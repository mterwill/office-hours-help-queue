class AddPriorityToCourseQueueEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :course_queue_entries, :priority, :integer, :default => 0, :null => false
  end
end
