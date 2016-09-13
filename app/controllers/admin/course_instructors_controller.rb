class Admin::CourseInstructorsController < Admin::AdminController
  before_action :set_and_authorize_course, only: :new

  def new
    @course_instructor = CourseInstructor.new
    @course_instructor.course = @course
  end

  def create
    @course_instructor = CourseInstructor.new
    @course_instructor.course = Course.find(params[:course_instructor][:course_id])

    unless current_user.instructor_for_course?(@course_instructor.course)
      return redirect_to root_url
    end

    @course_instructor.instructor = User.find_or_create_by({
      email: params[:instructor_email]
    })

    if @course_instructor.save
      redirect_to admin_course_url(@course_instructor.course)
    else
      render :new
    end
  end

  def destroy
    @course_instructor = CourseInstructor.find(params[:id])

    unless current_user.instructor_for_course?(@course_instructor.course)
      return redirect_to root_url
    end

    @course_instructor.destroy!

    redirect_to admin_course_url(@course_instructor.course)
  end

  private
  def set_and_authorize_course
    @course = Course.find_by!(slug: params[:id])

    unless @course.instructors.include?(current_user)
      redirect_to root_url
    end
  end
end
