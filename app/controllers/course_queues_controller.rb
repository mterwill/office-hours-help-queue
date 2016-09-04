class CourseQueuesController < ApplicationController
  before_action :set_course_queue, only: [:show]

  # GET /course_queues/1
  # GET /course_queues/1.json
  def show
  end

  private
  def set_course_queue
    @course_queue = CourseQueue.open_queues.find(params[:id])
  end
end
