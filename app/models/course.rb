class Course < ApplicationRecord
  has_many :course_queues
  has_many :course_instructors
  has_many :instructors, through: :course_instructors
  has_many :course_queue_entries, through: :course_queues

  # Produce a deterministic but secret code used to self-enroll instructors
  def enrollment_code
    OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      Rails.application.secrets.secret_key_base,
      "#{id}"
    ).upcase[0,8]
  end

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

  def get_contributions(who)
    key = who == :student ? 'requester_id' : 'resolver_id'

    ActiveRecord::Base.connection.execute(<<-SQL
      SELECT
        users.name,
        users.email,
        COUNT(*) c
      FROM
        course_queue_entries, course_queues, users
      WHERE
        course_queue_entries.course_queue_id = course_queues.id AND
        course_queue_entries.#{key} = users.id AND
        course_queues.course_id = #{id}
      GROUP BY
        users.name, users.email
      ORDER BY
        c DESC
      SQL
    )
  end

  def get_resolved_by_day
    ActiveRecord::Base.connection.execute(<<-SQL
      SELECT
        DATE(CONVERT_TZ(resolved_at, 'GMT', 'EST')) AS resolved_day,
        COUNT(*) AS resolved_day_count
      FROM
        course_queue_entries, course_queues
      WHERE
        course_queue_entries.course_queue_id = course_queues.id AND
        course_queues.course_id = #{id}
      GROUP BY
        resolved_day
      SQL
    )
  end

  def get_recently_resolved_requests(limit = 10)
    course_queue_entries.where.not(resolved_at: nil).order('resolved_at DESC').limit(limit)
  end

  def to_param
    slug
  end
end
