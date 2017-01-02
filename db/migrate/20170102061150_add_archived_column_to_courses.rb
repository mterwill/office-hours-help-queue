class AddArchivedColumnToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :archived, :boolean, null: false, default: false
  end
end
