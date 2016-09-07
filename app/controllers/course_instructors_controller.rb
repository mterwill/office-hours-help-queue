class CourseInstructorsController < ApplicationController
  before_action :set_course, :authorize_current_user

  def new
    @course_instructor = CourseInstructor.new
  end
  
  def create
    @course_instructor = CourseInstructor.new
    @course_instructor.course = @course
    @course_instructor.instructor = User.find_or_create_by({
      email: params[:instructor_email]
    })

    if @course_instructor.save
      redirect_to @course
    else
      render :new
    end
  end

  def destroy
    @course_instructor = CourseInstructor.find(params[:id])
    
    @course_instructor.destroy!

    redirect_to @course
  end

  private
  def set_course
    @course = Course.find(params[:course_id])
  end

  def authorize_current_user
    unless @course.instructors.include?(current_user)
      redirect_to root_url
    end
  end
end
