class InvalidRequestError < StandardError
end

class CourseQueue < ApplicationRecord
  belongs_to :course
  has_many :course_queue_entries
  has_many :course_queue_online_instructors, dependent: :destroy
  has_many :online_instructors, through: :course_queue_online_instructors, class_name: 'User'

  def request(requester:, description:, location:, group:, jitter_fn: lambda {rand(-10..10)})
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

      created_at = nil
      if self.add_requested_at_jitter and self.recently_opened?
        jitter_seconds = jitter_fn.call
        created_at = Time.now() + jitter_seconds
      end

      CourseQueueEntry.create!(
        course_queue: self,
        requester: requester,
        course_group: group,
        description: description,
        location: location,
        created_at: created_at,
      )
    end
  end

  def outstanding_requests
    course_queue_entries.where(resolved_at: nil).order('created_at ASC')
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

  def recently_opened?
    opened_at = CourseQueueOnlineInstructor.where({course_queue: self}).order('created_at ASC').pluck('created_at').first
    if opened_at.nil?
      return false
    end
    return Time.now - opened_at < 60
  end

  def is_open?
    self.online_instructors.count > 0
  end

  def self.open_queues
    where(is_open: true)
  end
end
