require 'test_helper'

class CourseGroupTest < ActiveSupport::TestCase
  test "the same student can be in the same group once" do
    assert_raise ActiveRecord::RecordInvalid do
      course_groups(:group1).students << users(:matt)
    end
  end

  test "the same student cannot be in multiple groups per course" do
    assert_raise ActiveRecord::RecordInvalid do
      course_groups(:group2).students << users(:matt)
    end
  end

  test "the same student can be in groups in multiple courses" do
    course_groups(:group3).students << users(:matt)
  end
end
