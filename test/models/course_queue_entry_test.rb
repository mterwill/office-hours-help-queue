require 'test_helper'

class CourseQueueEntryTest < ActiveSupport::TestCase
  test "should not save without valid course queue" do
    entry = CourseQueueEntry.new(
      requester: users(:matt)
    )

    assert_not entry.save
  end

  test "should not save without valid requester" do
    entry = CourseQueueEntry.new(
      course_queue: course_queues(:eecs398_queue)
    )

    assert_not entry.save
  end
end
