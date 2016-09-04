require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    @course = courses(:eecs398)
  end

  test "open queues returns only open queues" do
    open_queues = @course.open_queues

    assert     open_queues.include? course_queues(:eecs398_queue)
    assert_not open_queues.include? course_queues(:closed_queue)
  end
end
