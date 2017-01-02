class Admin::CourseInstructorsController < Admin::AdminController
  before_action :load_course, only: [:new, :promote]
  def new
    unless current_user.instructor_for_course?(@course)
      redirect_to root_url
    end
  end

  def promote
    # get/post map to the same action
    return render 'promote' unless request.post?

    unless params[:enrollment_code] == @course_instructor.course.enrollment_code
      # bad code
      return redirect_to root_url
    end

    unless current_user.instructor_for_course?(@course_instructor.course)
      # don't create duplicate instructors
      @course_instructor.instructor = current_user
      @course_instructor.save!
    end

    redirect_to course_url(@course_instructor.course)
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
  def load_course
    @course = Course.find_by!(slug: params[:id])
    @course_instructor = CourseInstructor.new
    @course_instructor.course = @course
  end
end
