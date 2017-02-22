class KeyOnStudentAndCourse < ActiveRecord::Migration[5.0]
  def change
    add_index :course_group_students, [ :student_id, :course_group_id ], unique: true
  end
end
