class CreateCourseQueueOnlineInstructors < ActiveRecord::Migration[5.0]
  def change
    create_table :course_queue_online_instructors do |t|
      t.integer :course_queue_id
      t.integer :online_instructor_id

      t.timestamps
    end
  end
end
