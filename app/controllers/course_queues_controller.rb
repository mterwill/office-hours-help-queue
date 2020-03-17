class CourseQueuesController < ApplicationController
  before_action :set_course_queue

  # GET /course_queues/1
  def show
    @is_instructor = current_user.instructor_for_course_queue?(@course_queue).to_s

    if course_group = current_user.course_group_for_course(@course_queue.course)
      @course_group_id = course_group.id.to_s
    else
      @course_group_id = "null" # this is going to get serialized
    end
  end

  # GET /course_queues/1/outstanding_requests.json
  def outstanding_requests
    @outstanding_requests = @course_queue.outstanding_requests
  end

  # GET /course_queues/1/online_instructors.json
  def online_instructors
    @instructors = @course_queue.online_instructors
  end

  # GET /course_queues/1/instructor_message.json
  def instructor_message
    @instructor_message = @course_queue.instructor_message
  end

  # GET /course_queues/1/other_queues.json
  def other_queues
    @queues = Course.find(@course_queue.course_id).course_queues.where.not(id: @course_queue.id).order(:name)
  end

  private
  def set_course_queue
    @course_queue = CourseQueue.find(params[:id])
  end
end
