class Course < ApplicationRecord
  has_many :course_queues
  has_many :course_instructors
  has_many :instructors, through: :course_instructors


  def available_queues_for(user)
    if user.instructor_for_course?(self)
      self.course_queues
    else
      self.open_queues
    end
  end

  def open_queues
    CourseQueue.joins(:course_queue_online_instructors).where(course_id: self.id).distinct
  end

  def to_param
    slug
  end
end
