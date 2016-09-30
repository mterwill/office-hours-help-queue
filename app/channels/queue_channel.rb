class QueueChannel < ApplicationCable::Channel
  include CourseQueuesHelper # TODO: find a better home

  def subscribed
    @course_queue = CourseQueue.find(params[:id])
    stream_for @course_queue
  end

  def new_request(data)
    authorize :open_queue

    new_request = @course_queue.request(
      requester: current_user,
      location: data['location'],
      description: data['description']
    )

    broadcast_request_change('new_request', new_request)
  end

  def resolve_request(data)
    authorize :instructor_only

    request = load_request(data)

    request.resolve_by!(current_user)

    broadcast_request_change('resolve_request', request)
  end

  def queue_pop(data)
    authorize :instructor_only

    request = @course_queue.pop!(current_user)

    broadcast_request_change('resolve_request', request)
  end

  def take_queue_offline(data)
    authorize :instructor_only

    @course_queue.online_instructors.map { |i| i.sign_out!(@course_queue) }
  end

  def instructor_status_toggle(data)
    authorize :instructor_only

    if data['online']
      current_user.sign_in!(@course_queue)
    else
      current_user.sign_out!(@course_queue)
    end
  end

  def destroy_request(data)
    request = load_request(data)

    authorize(:current_user, request)

    request.destroy!

    broadcast_request_change('resolve_request', request)
  end

  private
  def broadcast_request_change(action, request)
    QueueChannel.broadcast_to(@course_queue, {
      action: action,
      request: serialize_request(request),
    })
  end

  def load_request(data)
    @course_queue.outstanding_requests.find(data['id'])
  end

  def authorize(requirement, request = nil)
    if requirement == :instructor_only
      unless current_user.instructor_for_course_queue?(@course_queue)
        raise "Current user not instructor" 
      end
    elsif requirement == :current_user_only
      unless current_user == request.requester
        raise "Current user not requester" 
      end
    elsif requirement == :open_queue 
      raise "Queue is closed" unless @course_queue.is_open?
    end
  end
end
