module CourseQueuesHelper
  def serialize_request(request)
    request.as_json({
      include: {
      requester: { except: User::PROTECTED_FIELDS },
      resolver:  { except: User::PROTECTED_FIELDS }
    }})
  end
end
