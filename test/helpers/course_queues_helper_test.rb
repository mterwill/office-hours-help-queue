require 'test_helper'

class CourseQueuesHelperTest  < ActionView::TestCase
  test "private mode on" do
    @queue = course_queues(:private_mode_queue)

    bob_request = @queue.request(
      requester: users(:bob),
      description: 'shh',
      location: 'super secret',
      group: nil,
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
