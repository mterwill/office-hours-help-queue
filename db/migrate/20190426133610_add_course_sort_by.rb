class AddCourseSortBy < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :sorting, :integer, null: false, default: 0
  end
end
