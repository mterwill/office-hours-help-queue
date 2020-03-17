require 'test_helper'

class CourseQueuesHelperTest  < ActionView::TestCase
  test "private mode on" do
    @queue = course_queues(:private_mode_queue)

    bob_request = @queue.request(
      requester: users(:bob),
      description: 'shh',
      location: 'super secret',
      group: course_groups(:group4),
    )

    request_hash = serialize_request(bob_request)

    assert_nil(
      redact_request(request_hash, users(:jd))['description'],
      "students cannot see other students request description in private mode"
    )

    assert_nil(
      redact_request(request_hash, users(:jd))['location'],
      "students cannot see other students request location in private mode"
    )

    assert_nil(
      redact_request(request_hash, users(:mary))['description'],
      "students in the same group cannot see others description if group mode is off"
    )

    assert_nil(
      redact_request(request_hash, users(:mary))['location'],
      "students in the same group cannot see others location if group mode is off"
    )

    assert_equal(
      'shh',
      redact_request(request_hash, users(:bob))['description'],
      "students see their own description in private mode"
    )

    assert_equal(
      'super secret',
      redact_request(request_hash, users(:bob))['location'],
      "students see their own location in private mode"
    )

    assert_equal(
      'shh',
      redact_request(request_hash, users(:matt))['description'],
      "instructors see descriptions in private mode"
    )

    assert_equal(
      'super secret',
      redact_request(request_hash, users(:matt))['location'],
      "instructors see locations in private mode"
    )
  end

  test "private mode on with groups" do
    @queue = course_queues(:private_and_group_queue)

    jim_request = @queue.request(
      requester: users(:jim),
      description: 'shh',
      location: 'super secret',
      group: course_groups(:group4),
    )

    request_hash = serialize_request(jim_request)

    assert_nil(
      redact_request(request_hash, users(:jd))['description'],
      "students not in the same group cannot see the description"
    )

    assert_nil(
      redact_request(request_hash, users(:jd))['location'],
      "students not in the same group cannot see the location"
    )

    assert_equal(
      'shh',
      redact_request(request_hash, users(:mary))['description'],
      "students in the same group see the location"
    )

    assert_equal(
      'super secret',
      redact_request(request_hash, users(:mary))['location'],
      "students in the same group see the description"
    )
  end

  test "private mode off" do
    @queue = course_queues(:eecs398_queue)

    bob_request = @queue.request(
      requester: users(:bob),
      description: 'shh',
      location: 'super secret',
      group: nil,
    )

    request_hash = serialize_request(bob_request)

    assert_equal(
      'shh',
      redact_request(request_hash, users(:jd))['description'],
      "students see other students request description in normal mode"
    )

    assert_equal(
      'super secret',
      redact_request(request_hash, users(:jd))['location'],
      "students see other students request location in normal mode"
    )
  end
end
