class AddInstructorToCourseQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :course_queues, :instructor_message, :string
  end
end
