class AddAnonymousMode < ActiveRecord::Migration[5.0]
    def change
      add_column :course_queues, :anonymous, :boolean, null: false, default: false
    end
  end
  