class CoursesController < ApplicationController
  before_action :set_course_and_queues, except: [:index]

  def index
    @courses = Course.order(:name)
  end

  def show
  end

  private
  def set_course_and_queues
    @course = Course.find_by!(slug: params[:id])
    @queues = @course.available_queues_for(current_user).order(:name)
  end
end
