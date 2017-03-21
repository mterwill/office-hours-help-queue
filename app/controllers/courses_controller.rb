class CoursesController < ApplicationController
  before_action :set_course_and_queues, except: [:index, :archive]

  def index
    @courses = Course.where(archived: false).order(:name)
  end

  def archive
    @courses = Course.where(archived: true).order(:name)
  end

  def show
  end

  private
  def set_course_and_queues
    @course = Course.find_by!(slug: params[:id])
    @queues = @course.course_queues.order(:name)
  end
end
