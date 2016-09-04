class CourseQueue < ApplicationRecord
  belongs_to :course
  has_many :course_queue_entries

  def request(requester:, description: '')
    CourseQueueEntry.create!(
      requester: requester,
      description: description,
      course_queue: self,
    )
  end

  def outstanding_requests
    course_queue_entries.where.not(resolved_at: nil).order('created_at DESC')
  end

  def active_instructors
    User.all
  end

  def self.open_queues
    where(is_open: true)
  end
end
