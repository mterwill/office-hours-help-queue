class AddIndicies < ActiveRecord::Migration[5.0]
  def change
    # course_instructors
    add_index :course_instructors, [ :course_id, :instructor_id ], unique: true
    change_column_null :course_instructors, :course_id, false
    change_column_null :course_instructors, :instructor_id, false

    # course_queue_entries
    add_index :course_queue_entries, :course_queue_id
    change_column_null :course_queue_entries, :requester_id, false
    change_column_null :course_queue_entries, :course_queue_id, false

    # course_queue_online_instructors
    add_index :course_queue_online_instructors, :course_queue_id
    change_column_null :course_queue_online_instructors, :course_queue_id, false
    change_column_null :course_queue_online_instructors, :online_instructor_id, false

    # course_queues
    add_index :course_queues, [ :course_id, :name ], unique: true
    change_column_null :course_queues, :course_id, false
    change_column_null :course_queues, :name, false

    # courses
    add_index :courses, :name, unique: true
    add_index :courses, :slug, unique: true
    change_column_null :courses, :slug, false
    change_column_null :courses, :name, false
    change_column_null :courses, :long_name, false

    # users
    add_index :users, :email, unique: true
    change_column_null :users, :email, false
  end
end
