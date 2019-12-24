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
    if course.sort_by_number_of_resolved_requests_this_session?
      if !course_queue_online_instructors.nil?
        # Find when queue openned

        start = course_queue_online_instructors.select(:created_at).minimum(:created_at) || 0
        # Order
        course_queue_entries
        .joins(<<-SQL
            LEFT JOIN (SELECT C.requester_id as pivot_r_id, COUNT(C.requester_id) AS cnt
            FROM course_queue_entries C
            WHERE C.course_queue_id = #{id}
                  AND C.course_group_id IS NULL
                  AND C.resolver_id IS NOT NULL
                  AND created_at >= "#{start}"
            GROUP BY pivot_r_id) T on requester_id = T.pivot_r_id
          SQL
        )
        .where(resolved_at: nil)
        .order("T.cnt, created_at ASC")
      end
    else
      course_queue_entries.where(resolved_at: nil).order('created_at ASC')
    end
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

  def is_open?
    self.online_instructors.count > 0
  end

  def self.open_queues
    where(is_open: true)
  end
end
