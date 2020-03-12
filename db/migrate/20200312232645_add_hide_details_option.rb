class AddHideDetailsOption < ActiveRecord::Migration[5.0]
  def change
    add_column :course_queues, :hide_details_from_students, :boolean, null: false, default: false
  end
end
