class AddFieldsToCourseQueueEntry < ActiveRecord::Migration[5.0]
  def change
    add_column(:course_queue_entries, :location, :string)
  end
end
