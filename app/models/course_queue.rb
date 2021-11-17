class InvalidRequestError < StandardError
end

class CourseQueue < ApplicationRecord
  belongs_to :course
  has_many :course_queue_entries
  has_many :course_queue_online_instructors, dependent: :destroy
  has_many :online_instructors, through: :course_queue_online_instructors, class_name: 'User'

  def request(requester:, description:, location:, group:)
    self.with_lock do
      # Check the user's request limit for the course
      if self.course.course_queue_entries.where(resolved_at: nil, requester: requester).count > 0
          raise InvalidRequestError, "Limit one open request per user per course"
      end

      if exclusive && group == nil && !requester.instructor_for_course_queue?(self)
        raise InvalidRequestError, "Only enrolled students may use this queue."
      end

      # Now the group's
      count = outstanding_requests.where(course_group: group).count
      if group_mode && group && count > 0
        raise InvalidRequestError, "Limit one open request per group"
      end

      CourseQueueEntry.create!(
        course_queue: self,
        requester: requester,
        course_group: group,
        description: description,
        location: location,
      )
    end
  end

  def outstanding_requests
    course_queue_entries.where(resolved_at: nil).order('priority DESC, created_at ASC')
  end

  def update_instructor_message!(message)
      self.instructor_message = message
      self.save!
  end

  def pop!(user)
    if first_pinned = self.outstanding_requests.where(resolver: user).first
      first_pinned.resolve_by!(user)
    elsif first_non_pinned = self.outstanding_requests.where(resolver: nil).first
      first_non_pinned.resolve_by!(user)
    elsif first_pinned_by_others = self.outstanding_requests.where.not(resolver: user).first
      first_pinned_by_others.resolve_by!(user)
    end
  end

  def shuffle!()
    CourseQueueEntry.transaction do
      randomized_requests = outstanding_requests.to_a.shuffle
      randomized_requests.each_with_index do |request, idx|
        request.priority = randomized_requests.length - idx
        request.save!
      end
    end
  end

  def is_open?
    self.online_instructors.count > 0
  end

  def self.open_queues
    where(is_open: true)
  end
end
