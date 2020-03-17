module CourseQueuesHelper
  def serialize_request(request)
    request.as_json({
      include: {
        requester: { except: User::PROTECTED_FIELDS },
        resolver:  { except: User::PROTECTED_FIELDS }
      }
    })
  end

  def redact_request(request_hash, current_user)
    course_queue = CourseQueue.find(request_hash['course_queue_id'])

    request_is_from_current_user = request_hash['requester_id'] == current_user.id
    current_user_is_instructor = current_user.instructor_for_course_queue? course_queue
    private_mode = course_queue.hide_details_from_students

    request_is_from_same_group = false
    if course_queue.group_mode && request_hash['course_group_id']
      group = CourseGroup.find(request_hash['course_group_id'])
      request_is_from_same_group = group.students.include? current_user
    end

    should_redact = private_mode &&
      !request_is_from_current_user &&
      !request_is_from_same_group &&
      !current_user_is_instructor

    if should_redact
      return request_hash.except('location', 'description')
    else
      return request_hash
    end
  end

  def serialize_queue_ids(queue)
    queue.as_json(only: [:id]).map { |entry| entry["id"] }
  end

  def serialize_queue(queue)
    queue.as_json(only: [:id, :name])
  end
end
