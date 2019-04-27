class AddCourseSortBy < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :sort_by, :boolean, null: false, default: false
  end
end
