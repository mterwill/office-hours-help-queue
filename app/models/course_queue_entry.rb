class CourseQueueEntry < ApplicationRecord
  belongs_to :course_queue
  has_one :course, through: :course_queue
  belongs_to :requester, class_name: 'User'
  belongs_to :resolver, class_name: 'User', required: false

  def is_requester?(user)
    user == self.requester
  end

  def resolve_by!(user)
    self.resolver    = user
    self.resolved_at = DateTime.now

    self.save!

    self
  end
end
