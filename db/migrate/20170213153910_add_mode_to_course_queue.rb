class AddModeToCourseQueue < ActiveRecord::Migration[5.0]
  def change
    add_column :course_queues, :group_mode, :boolean, null: false, default: false
  end
end
