class Course < ApplicationRecord
  has_many :course_queues

  def open_queues
    course_queues.where(is_open: true)
  end
end
