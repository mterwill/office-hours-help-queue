class CreateCourseQueueEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :course_queue_entries do |t|
      t.integer :requester_id
      t.integer :course_queue_id
      t.text :description
      t.integer :resolver_id
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
