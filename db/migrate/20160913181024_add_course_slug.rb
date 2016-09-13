class AddCourseSlug < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :slug, :string
  end
end
