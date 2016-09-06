class CourseQueueOnlineInstructor < ApplicationRecord
  belongs_to :course_queue
  belongs_to :online_instructor, class_name: 'User'
end
