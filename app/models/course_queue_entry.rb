class CourseQueueEntry < ApplicationRecord
  belongs_to :course_queue
  belongs_to :requester, class_name: 'User'
  belongs_to :resolver, class_name: 'User', required: false
end
