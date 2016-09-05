class CourseQueue < ApplicationRecord
  belongs_to :course
  has_many :course_queue_entries

  def request(requester:, description:, location:)
    logger.debug "fdswa#{description}"
    logger.debug "asdf#{location}"
    CourseQueueEntry.create!(
      course_queue: self,
      requester: requester,
      description: description,
      location: location,
    )
  end

  def open!
    self.update!(is_open: true)
  end

  def outstanding_requests
    course_queue_entries.where(resolved_at: nil).order('created_at ASC')
  end

  def active_instructors
    User.all
  end

  def self.open_queues
    where(is_open: true)
  end
end
