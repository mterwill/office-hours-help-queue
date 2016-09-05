class QueueChannel < ApplicationCable::Channel
  def subscribed
    @course_queue = CourseQueue.find(params[:id])
    stream_for @course_queue
  end

  def new_request(data)
    new_request = @course_queue.request(
      requester: current_user,
      location: data['location'],
      description: data['description']
    )

    broadcast_request_change('new_request', new_request)
  end

  def resolve_request(data)
    request = load_request(data)

    # TODO authenticate this

    request.resolve_by!(current_user)

    broadcast_request_change('resolve_request', request)
  end

  def destroy_request(data)
    request = load_request(data)

    # TODO authenticate this

    request.destroy!

    broadcast_request_change('destroy_request', request)
  end

  def update_request(data)
  end

  private
  def broadcast_request_change(action, request)
    QueueChannel.broadcast_to(@course_queue, {
      action: action,
      request: serialize_request(request),
      outstanding_request_count: @course_queue.outstanding_requests.count,
    })
  end

  def load_request(data)
    @course_queue.outstanding_requests.find(data['id'])
  end

  def serialize_request(request)
    request.as_json({
      include: {
      requester: { except: User::PROTECTED_FIELDS },
      resolver:  { except: User::PROTECTED_FIELDS }
    }})
  end
end
