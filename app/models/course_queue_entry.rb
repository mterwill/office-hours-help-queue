class CourseQueueEntry < ApplicationRecord
  belongs_to :course_queue
  has_one :course, through: :course_queue
  belongs_to :course_group, required: false
  belongs_to :requester, class_name: 'User'
  belongs_to :resolver, class_name: 'User', required: false

  validates_length_of :location, maximum: 50, allow_blank: true
  validates_length_of :description, maximum: 100, allow_blank: true

  def resolve_by!(user)
    self.resolver    = user
    self.resolved_at = DateTime.now

    self.save!

    self
  end
end
