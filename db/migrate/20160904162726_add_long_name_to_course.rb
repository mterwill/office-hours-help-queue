class AddLongNameToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column(:courses, :long_name, :string)
  end
end
