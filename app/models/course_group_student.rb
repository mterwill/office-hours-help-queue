class CourseGroupStudent < ApplicationRecord
  belongs_to :course_group
  delegate :course, to: :course_group
  belongs_to :student, class_name: 'User'

  validate :student_not_already_in_group_for_course

  def student_not_already_in_group_for_course
    if CourseGroupStudent.joins(:course_group)
                      .where('course_groups.course_id': course_group.course.id,
                             student: student)
                      .count > 0
      errors.add(:student_id, "#{student.email} already belongs to a group in this course.")
    end
  end
end
