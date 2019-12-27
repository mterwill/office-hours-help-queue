require 'test_helper'

class CourseQueueTest < ActiveSupport::TestCase
  setup do
    @queue       = course_queues(:eecs398_queue)
    @queue_sort  = course_queues(:eecs281_sorting_resolves_queue)
    @group_queue = course_queues(:eecs482_group_queue)
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

    last_entry = @queue.request(
      requester: users(:jim),
      description: '',
      location: '',
      group: nil
    )

    assert @queue.outstanding_requests[-1] == last_entry
  end

  test "request are sorted by number of previously resolved requests" do

    assert @queue_sort.course_queue_entries.blank?
    assert @queue_sort.course.sort_by_number_of_resolved_requests_this_session?

    entry_sue_1 = @queue_sort.request(
      requester: users(:sue),
      description: 'sue 1',
      location: '',
      group: nil
    )

    entry_sue_1.resolve_by!(users(:matt))

    assert @queue_sort.outstanding_requests.where(resolved_at: nil).blank?

    entry_sue_2 = @queue_sort.request(
      requester: users(:sue),
      description: 'sue 2',
      location: '',
      group: nil
    )

    entry_sue_2.resolve_by!(users(:matt))

    assert @queue_sort.outstanding_requests.where(resolved_at: nil).blank?

    entry_sue_3 = @queue_sort.request(
      requester: users(:sue),
      description: 'sue 3',
      location: '',
      group: nil
    )

    entry_sue_3.resolve_by!(users(:matt))

    assert @queue_sort.outstanding_requests.where(resolved_at: nil).blank?

    entry_sue_4 = @queue_sort.request(
      requester: users(:sue),
      description: 'sue 4',
      location: '',
      group: nil
    )

    entry_jim_1 = @queue_sort.request(
      requester: users(:jim),
      description: 'jim 1',
      location: '',
      group: nil
    )

    entry_jim_1.resolve_by!(users(:matt))

    entry_steve_1 = @queue_sort.request(
      requester: users(:steve),
      description: 'steve 1',
      location: '',
      group: nil
    )

    assert @queue_sort.outstanding_requests[0] == entry_steve_1

    entry_steve_1.resolve_by!(users(:matt))

    entry_steve_2 = @queue_sort.request(
      requester: users(:steve),
      description: 'steve 2',
      location: '',
      group: nil
    )

    entry_jim_2 = @queue_sort.request(
      requester: users(:jim),
      description: 'jim 2',
      location: '',
      group: nil
    )

    entry_jim_2.resolve_by!(users(:matt))

    entry_jim_3 = @queue_sort.request(
      requester: users(:jim),
      description: 'jim 3',
      location: '',
      group: nil
    )

    assert @queue_sort.outstanding_requests[0] == entry_steve_2
    assert @queue_sort.outstanding_requests[1] == entry_jim_3
    assert @queue_sort.outstanding_requests[2] == entry_sue_4

    # On tie, sort by timestamp

    entry_jim_3.resolve_by!(users(:matt))

    entry_jim_4 = @queue_sort.request(
      requester: users(:jim),
      description: 'jim 4',
      location: '',
      group: nil
    )

    assert @queue_sort.outstanding_requests[0] == entry_steve_2
    assert @queue_sort.outstanding_requests[1] == entry_sue_4
    assert @queue_sort.outstanding_requests[2] == entry_jim_4

    # close queue and reopen, should "reset"
    # need to sleep to make timestamps different
    sleep(3)

    @queue_sort.online_instructors.map { |i| i.sign_out!(@course_queue) }
    @queue_sort.outstanding_requests.each do |request|
      request.destroy!
    end

    assert @queue_sort.outstanding_requests.blank?

    users(:matt).sign_in!(@queue_sort)

    entry_steve_2_1 = @queue_sort.request(
      requester: users(:steve),
      description: 'steve 2_1',
      location: '',
      group: nil
    )

    entry_steve_2_1.resolve_by!(users(:matt))

    entry_steve_2_2 = @queue_sort.request(
      requester: users(:steve),
      description: 'steve 2_2',
      location: '',
      group: nil
    )

    entry_sue_2_1 = @queue_sort.request(
      requester: users(:sue),
      description: 'sue 2_1',
      location: '',
      group: nil
    )

    assert @queue_sort.outstanding_requests[0] == entry_sue_2_1
    assert @queue_sort.outstanding_requests[1] == entry_steve_2_2

  end

  test "group request are sorted by number of previously resolved group requests" do
    assert @queue_sort.course.sort_by_number_of_resolved_requests_this_session?
    @queue_sort.update!(group_mode: true)

    entry_group1_1 = @queue_sort.request(
      requester: users(:steve),
      description: 'group 1 request',
      location: '',
      group: course_groups(:group1)
    )

    entry_group1_1.resolve_by!(users(:sue))

    entry_group1_2 = @queue_sort.request(
      requester: users(:matt),
      description: 'second request of group 1 from different person',
      location: '',
      group: course_groups(:group1)
    )

    entry_group2_1 = @queue_sort.request(
      requester: users(:jim),
      description: 'group 2 request',
      location: '',
      group: course_groups(:group2)
    )

    assert @queue_sort.outstanding_requests[0] == entry_group2_1
    assert @queue_sort.outstanding_requests[1] == entry_group1_2

    entry_group2_1.resolve_by!(users(:sue))

    entry_group2_2 = @queue_sort.request(
      requester: users(:mary),
      description: 'second request of group 2 from different person',
      location: '',
      group: course_groups(:group2)
    )

    assert @queue_sort.outstanding_requests[0] == entry_group1_2
    assert @queue_sort.outstanding_requests[1] == entry_group2_2
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

  test "open queues returns only open queues" do
    open_queues = CourseQueue.open_queues

    assert     open_queues.include? course_queues(:eecs398_queue)
    assert_not open_queues.include? course_queues(:closed_queue)
  end
end
