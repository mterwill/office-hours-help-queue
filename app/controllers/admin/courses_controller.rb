class Admin::CoursesController < Admin::AdminController
  before_action :set_course, :authorize_current_user, except: [:index]

  def show
    @queues      = @course.course_queues.order(:name)
    @instructors = @course.course_instructors.joins(:instructor).order("users.name")
  end

  private
  def set_course
    @course = Course.find_by!(slug: params[:id])
  end

  def authorize_current_user
    unless current_user.instructor_for_course?(@course)
      redirect_to root_url
    end
  end
end
