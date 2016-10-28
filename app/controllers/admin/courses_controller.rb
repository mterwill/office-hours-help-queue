class Admin::CoursesController < Admin::AdminController
  before_action :set_course, :authorize_current_user, except: [:index, :new, :create]
  before_action :authorize_global_admin, except: [:show, :edit, :update]

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to admin_course_url(@course)
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      redirect_to admin_course_url(@course)
    else
      render :edit
    end
  end

  def destroy
    @course.destroy!
    redirect_to admin_courses_url
  end

  def show
    @queues      = @course.course_queues.order(:name)
    @instructors = @course.course_instructors.joins(:instructor).order("users.name")
  end

  private
  def course_params
    params.require(:course).permit(:name, :long_name, :slug)
  end

  def set_course
    @course = Course.find_by!(slug: params[:id])
  end

  def authorize_current_user
    unless current_user.instructor_for_course?(@course)
      redirect_to root_url
    end
  end

  def authorize_global_admin
    unless current_user.global_admin?
      redirect_to root_url
    end
  end
end
