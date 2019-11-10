class User < ApplicationRecord
  PROTECTED_FIELDS = %w(oauth_token oauth_expires_at uid provider)

  validates_length_of :nickname, maximum: 25, allow_blank: true

  def self.from_omniauth(auth)
    # TODO: we want to unique key on email here, but the provider/uid combo that
    # was here is more conducive to actual omniauth
    where(email: auth.info.email).first_or_initialize.tap do |user|
      user.provider         = auth.provider
      user.uid              = auth.uid
      user.name             = auth.info.name
      user.email            = auth.info.email
      user.avatar_url       = auth.info.image
      user.oauth_token      = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

      if User.count == 0
        user.global_admin = true
      end

      user.save!
    end
  end

  def instructor_for_course?(course)
    !!(CourseInstructor.where({ instructor: self, course: course }).count > 0 || self.global_admin)
  end

  def instructor_for_course_queue?(course_queue)
    instructor_for_course?(course_queue.course)
  end

  def sign_in!(course_queue)
    CourseQueueOnlineInstructor.find_or_create_by(
      online_instructor: self,
      course_queue: course_queue
    )

    QueueChannel.broadcast_to(course_queue, {
      action: 'instructor_online',
      instructor: self,
    })
  end

  def sign_out!(course_queue)
    CourseQueueOnlineInstructor.where({
      online_instructor: self,
      course_queue: course_queue
    }).destroy_all

    QueueChannel.broadcast_to(course_queue, {
      action: 'instructor_offline',
      instructor: self,
    })
  end

  def as_json(options = {})
    super(options.merge({
      except: User::PROTECTED_FIELDS
    }))
  end

  def course_group_for_course(course)
    id = CourseGroupStudent.joins(:course_group)
                           .where('course_groups.course_id': course.id, student: self)
                           .pluck(:course_group_id)
                           .first

    id.nil? ? nil : CourseGroup.find(id)
  end
end
