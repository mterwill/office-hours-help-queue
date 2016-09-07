class CoursesController < ApplicationController
  before_action :set_course, :authorize_current_user

  def show
  end

  private
  def set_course
    @course = Course.find(params[:id])
  end

  def authorize_current_user
    unless @course.instructors.include?(current_user)
      redirect_to root_url
    end
  end
end
