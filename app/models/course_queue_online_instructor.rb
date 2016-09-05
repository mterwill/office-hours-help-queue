class CourseQueueOnlineInstructor < ApplicationRecord
  belongs_to :course_queue
  belongs_to :online_instructor, class_name: 'User'

  def sign_in!
    self.update!(online: true)
  end

  def sign_out!
    self.update!(online: false)
  end
end
