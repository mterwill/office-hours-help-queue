class CourseQueuesController < ApplicationController
  before_action :set_course_queue

  # GET /course_queues/1
  def show
    @is_instructor =current_user.instructor_for_course_queue?(@course_queue).to_s 
  end

  # GET /course_queues/1/outstanding_requests.json
  def outstanding_requests
    @outstanding_requests = @course_queue.outstanding_requests
  end

  # GET /course_queues/1/online_instructors.json
  def online_instructors
    @instructors = @course_queue.online_instructors
  end

  private
  def set_course_queue
    @course_queue = CourseQueue.find(params[:id])
  end
end
