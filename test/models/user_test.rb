require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "course_group_for_course returns nil if no course" do
    group = users(:matt).course_group_for_course(courses(:eecs398))
    assert group == nil
  end

  test "course_group_for_course returns the correct CourseGroup" do
    group = users(:matt).course_group_for_course(courses(:eecs482))
    assert group == course_groups(:group1)
  end
end
