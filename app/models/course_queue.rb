class CourseQueue < ApplicationRecord
  belongs_to :course
  has_many :course_queue_entries
  has_many :course_queue_online_instructors
  has_many :online_instructors, through: :course_queue_online_instructors, class_name: 'User'

  def request(requester:, description:, location:)
    if outstanding_requests.where(requester: requester).count > 0
      raise "Limit one open request per user"
    end

    CourseQueueEntry.create!(
      course_queue: self,
      requester: requester,
      description: description,
      location: location,
    )
  end

  def outstanding_requests
    course_queue_entries.where(resolved_at: nil).order('created_at ASC')
  end

  def pop!(user)
    self.outstanding_requests.first.resolve_by!(user)
  end

  def is_open?
    self.online_instructors.count > 0
  end

  def self.open_queues
    where(is_open: true)
  end
end
