class CourseQueuesController < ApplicationController
  ADMIN_ACTIONS = %w(new create destroy edit update)

  before_action :set_course_queue, except: [:new, :create]
  before_action :set_course, only: ADMIN_ACTIONS
  before_action :authorize_current_user, only: ADMIN_ACTIONS

  # GET /course_queues/1
  # GET /course_queues/1.json
  def show
  end

  def new
    @course_queue = CourseQueue.new
  end

  def create
    @course_queue = CourseQueue.new(course_queue_params)

    @course_queue.course = @course

    if @course_queue.save
      redirect_to @course
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @course_queue.update(course_queue_params)
      redirect_to @course
    else
      render :edit
    end
  end

  def destroy
    @course_queue.destroy!

    redirect_to @course
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

  def set_course
    @course = Course.find(params[:course_id])
  end

  def course_queue_params
    params.require(:course_queue).permit(:name, :location, :description)
  end

  def authorize_current_user
    unless @course.instructors.include?(current_user)
      redirect_to root_url
    end
  end
end
