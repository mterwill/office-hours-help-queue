class CourseGroup < ApplicationRecord
  belongs_to :course
  has_many :course_group_students, dependent: :destroy
  has_many :students, through: :course_group_students, class_name: 'User'
end
