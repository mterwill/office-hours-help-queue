class CreateCourseQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :course_queues do |t|
      t.string :name
      t.string :location
      t.text :description
      t.boolean :is_open
      t.integer :course_id

      t.timestamps
    end
  end
end
