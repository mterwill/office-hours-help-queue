class QueueChannel < ApplicationCable::Channel
  include CourseQueuesHelper # TODO: find a better home

  def subscribed
    @course_queue = CourseQueue.find(params[:id])
    stream_for @course_queue
  end

  def new_request(data)
    authorize :open_queue

    begin
      new_request = @course_queue.request(
        requester: current_user,
        group: current_user.course_group_for_course(@course_queue.course),
        location: data['location'],
        description: data['description']
      )

      broadcast_request_change('new_request', new_request)
    rescue InvalidRequestError => e
      QueueChannel.broadcast_to(@course_queue, {
        action: 'invalid_request',
        error: e.message,
      })
    end
  end

  def bump(data)
    authorize :instructor_only

    request = load_request(data)

    QueueChannel.broadcast_to(@course_queue, {
      action: 'bump',
      requester_id: request.requester.id,
      bump_by: current_user
    })
  end

  def update_instructor_message(data)
      authorize :instructor_only
      @course_queue.update_instructor_message!(data['message'])

      QueueChannel.broadcast_to(@course_queue, {
          action: 'update_instructor_message',
          message: data['message'],
      })

  end

  def broadcast_instructor_message(data)
      authorize :instructor_only

      QueueChannel.broadcast_to(@course_queue, {
        action: 'broadcast_instructor_message',
        message: data['message'],
        instructor: current_user,
      })
  end

  def pin(data)
    authorize :instructor_only

    request = load_request(data)

    if request.resolver # unpin
      request.update! resolver: nil
    else # pin
      request.update! resolver: current_user
    end

    broadcast_request_change('update_request', request)
  end

  def update_request(data)
    request = load_request(data)
    authorize(:current_user_only, request)

    request.update!(
      location: data['location'],
      description: data['description']
    )

    broadcast_request_change('update_request', request)
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

  def empty_queue(data)
    authorize :instructor_only

    @course_queue.outstanding_requests.each do |request|
      broadcast_request_change('resolve_request', request)
      request.destroy!
    end
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

    authorize(:current_user_only, request)

    request.destroy!

    broadcast_request_change('resolve_request', request)
  end

  def merge(data)
    authorize :instructor_only
    @to_course_queue = CourseQueue.find(data['to'])

    unless current_user.instructor_for_course_queue?(@to_course_queue)
      raise "Current user not instructor."
    end

    @course_queue.outstanding_requests.each do |request|
      request.update! course_queue_id: data['to']
      QueueChannel.broadcast_to(@course_queue, {
        action: 'move_request',
        request: serialize_request(request),
        move_to_id: @to_course_queue.name.html_safe, 
        move_to_url: @to_course_queue.id
      })
      QueueChannel.broadcast_to(@to_course_queue, {
        action: 'new_request',
        request: serialize_request(request),
      })
    end

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
      group = current_user.course_group_for_course(@course_queue.course)
      if current_user == request.requester
        return
      elsif @course_queue.group_mode && group && group.id == request.course_group_id
        return
      else
        raise "Current user not requester"
      end
    elsif requirement == :open_queue
      raise "Queue is closed" unless @course_queue.is_open?
    else
      raise "Invalid option"
    end
  end
end
