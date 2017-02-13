class CourseGroupStudent < ApplicationRecord
  belongs_to :course_group
  delegate :course, to: :course_group
  belongs_to :student, class_name: 'User'
end
