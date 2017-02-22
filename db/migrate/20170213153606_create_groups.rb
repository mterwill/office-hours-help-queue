class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :course_groups do |t|
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
