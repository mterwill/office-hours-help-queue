class CourseQueuesController < ApplicationController
  before_action :set_course_queue, only: [:show, :outstanding_requests]

  # GET /course_queues/1
  # GET /course_queues/1.json
  def show
  end

  # GET /course_queues/1
  # GET /course_queues/1.json
  def outstanding_requests
    @outstanding_requests = @course_queue.outstanding_requests
  end

  private
  def set_course_queue
    @course_queue = CourseQueue.open_queues.find(params[:id])
  end
end
