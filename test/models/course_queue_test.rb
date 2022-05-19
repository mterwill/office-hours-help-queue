require 'test_helper'

class CourseQueueTest < ActiveSupport::TestCase
  setup do
    @queue       = course_queues(:eecs398_queue)
    @group_queue = course_queues(:eecs482_group_queue)
    @jitter_queue = course_queues(:eecs482_jitter_queue)
    @requester   = users(:matt)
  end

  test "request creates a new CourseQueueEntry for this queue" do
    entry = @queue.request(
      requester: @requester,
      description: '',
      location: '',
      group: nil
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
      location: '',
      group: nil
    )

    # sorting by created_at races creation here
    last_entry = nil
    travel 10.seconds do
      last_entry = @queue.request(
        requester: users(:jim),
        description: '',
        location: '',
        group: nil
      )
    end

    assert_equal(last_entry, @queue.outstanding_requests[-1])
  end

  test "request validates duplicates" do
    assert_raise InvalidRequestError do
      2.times {
        @queue.request(
          requester: users(:steve),
          description: '',
          location: '',
          group: nil
        )
      }
    end
  end

  test "pop pops your pinned entry first" do
    pinned_by_matt = @queue.request(
      requester: users(:steve),
      description: '',
      location: '',
      group: nil
    )

    pinned_by_matt.update!(resolver: users(:matt))

    request = @queue.pop!(users(:matt))

    assert request == pinned_by_matt
  end

  test "pop respects others pinned entries" do
    pinned_by_matt = @queue.request(
      requester: users(:steve),
      description: '',
      location: '',
      group: nil
    )

    pinned_by_matt.update!(resolver: users(:matt))

    request = @queue.pop!(users(:jim))

    assert request == course_queue_entries(:unresolved_entry)

    # if the queue is empty we will allow entries pinned by others to be popped
    assert @queue.pop!(users(:jim)) == pinned_by_matt
  end

  test "request validates duplicates in group mode" do
    @group_queue.request(
      requester: users(:steve),
      description: '',
      location: '',
      group: course_groups(:group1)
    )

    assert_raise InvalidRequestError do
      @group_queue.request(
        requester: users(:matt),
        description: '',
        location: '',
        group: course_groups(:group1)
      )
    end
  end

  test "request ignores group if group mode is off" do
    @group_queue.update!(group_mode: false)

    @group_queue.request(
      requester: users(:steve),
      description: '',
      location: '',
      group: course_groups(:group1)
    )

    @group_queue.request(
      requester: users(:matt),
      description: '',
      location: '',
      group: course_groups(:group1)
    )
  end

  test "jitter" do
    # queue opened at midnight
    CourseQueueOnlineInstructor.create!(
      online_instructor: users(:jim),
      course_queue: @jitter_queue,
      created_at: Time.parse("2022-05-19 00:00:00")
    )
    # another instructor came online an hour later
    CourseQueueOnlineInstructor.create!(
      online_instructor: users(:matt),
      course_queue: @jitter_queue,
      created_at: Time.parse("2022-05-19 01:00:00")
    )

    # 10 seconds past queue open
    travel_to Time.parse("2022-05-19 00:00:10") do
      assert_equal(true, @jitter_queue.recently_opened?)
      entry = @jitter_queue.request(
        requester: users(:jim),
        description: '',
        location: '',
        group: nil,
        jitter_fn: lambda {-10},
      )
      assert_equal(
        Time.parse("2022-05-19 00:00:00"),
         entry.created_at,
         "jitter should be added",
      )
    end

    # 1 minute 10 seconds past queue open
    travel_to Time.parse("2022-05-19 00:01:10") do
      assert_equal(false, @jitter_queue.recently_opened?)
      entry = @jitter_queue.request(
        requester: users(:matt),
        description: '',
        location: '',
        group: nil,
        jitter_fn: lambda {-10},
      )
      assert_equal(
        Time.parse("2022-05-19 00:01:10"),
        entry.created_at,
        "jitter should not be added",
      )
    end
  end

  test "open queues returns only open queues" do
    open_queues = CourseQueue.open_queues

    assert     open_queues.include? course_queues(:eecs398_queue)
    assert_not open_queues.include? course_queues(:closed_queue)
  end
end
