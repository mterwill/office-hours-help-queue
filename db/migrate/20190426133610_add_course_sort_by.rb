class AddCourseSortBy < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :sort_by, :integer, null: false, default: 0
  end
end
