class CreateCourseGroupStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :course_group_students do |t|
      t.integer :course_group_id, null: false
      t.integer :student_id, null: false
    end

    add_index :course_group_students, :student_id
  end
end
