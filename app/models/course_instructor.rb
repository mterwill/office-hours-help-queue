class CourseInstructor < ApplicationRecord
  belongs_to :course
  belongs_to :instructor, class_name: 'User'

  validate :course_instructor_already_exists

  def course_instructor_already_exists
    if course.course_instructors.find_by(instructor: instructor)
      errors.add(:instructor, "already exists for this course")
    end
  end
end
