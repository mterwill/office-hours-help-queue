task :make_admin, [:course_id, :email] => :environment do |task, args|
  instructor = User.find_or_create_by({
    email: :email
  })

  puts CourseInstructor.create!(
    course_id: args.course_id,
    instructor: instructor
  )
end
