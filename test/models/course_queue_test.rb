require 'test_helper'

class CourseQueueTest < ActiveSupport::TestCase
  setup do
    @queue     = course_queues(:eecs398_queue)
    @requester = users(:matt)
  end

  test "request creates a new CourseQueueEntry for this queue" do
    entry = @queue.request(
      requester: @requester,
      description: '',
      location: ''
    )

    assert entry.course_queue == @queue
    assert entry.requester == @requester

    assert @queue.course_queue_entries.last == entry
  end

  test "outstanding requests returns only unresolved entries" do
    assert @queue.outstanding_requests.include?(
      course_queue_entries(:unresolved_entry)
    )

    assert_not @queue.outstanding_requests.include?(
      course_queue_entries(:resolved_entry)
    )
  end

  test "request adds you to the bottom of the queue" do
    first_entry = @queue.request(
      requester: users(:sue),
      description: '',
      location: ''
    )

    last_entry = @queue.request(
      requester: users(:jim),
      description: '',
      location: ''
    )

    assert @queue.outstanding_requests[-1] == last_entry
  end

  test "request validates duplicates" do
    assert_raise do
      2.times {
        @queue.request(
          requester: users(:steve),
          description: '',
          location: ''
        )
      }
    end
  end

  test "open queues returns only open queues" do
    open_queues = CourseQueue.open_queues

    assert     open_queues.include? course_queues(:eecs398_queue)
    assert_not open_queues.include? course_queues(:closed_queue)
  end
end
