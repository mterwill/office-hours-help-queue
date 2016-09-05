module CourseQueuesHelper
  def can_create?(request)
    # TODO: only if they don't have anything else on the queue (configurable)
    true
  end

  def can_update?(request)
    current_user.instructor_for?(request.course) ||
      request.is_requester?(current_user)
  end

  def can_destroy?(request)
    current_user.instructor_for?(request.course) ||
      request.is_requester?(current_user)
  end

  def can_resolve?(request)
    current_user.instructor_for?(request.course)
  end
end
