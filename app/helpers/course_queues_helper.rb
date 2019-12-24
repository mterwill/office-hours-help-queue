module CourseQueuesHelper
  def serialize_request(request)
    request.as_json({
      include: {
      requester: { except: User::PROTECTED_FIELDS },
      resolver:  { except: User::PROTECTED_FIELDS }
    }})
  end

  def serialize_queue_ids(queue)
    queue.as_json(only: [:id]).map { |entry| entry["id"] }
  end
end
