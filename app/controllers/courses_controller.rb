class CoursesController < ApplicationController
  before_action :set_course, :authorize_current_user

  def show
  end

  private
  def set_course
    @course = Course.find(params[:id])
    @course_instructors = @course.course_instructors.joins(:instructor).order("users.name")
  end

  def authorize_current_user
    unless @course.instructors.include?(current_user)
      redirect_to root_url
    end
  end
end
