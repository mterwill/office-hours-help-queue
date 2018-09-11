# Archive courses by simply renaming them
task :archive_courses => :environment do
  puts "This script will duplicate and archive all currently active courses to a term you input."
  printf('Enter term: ')
  term = STDIN.gets.strip.downcase

  # Wrapping everything in a transaction gives us an easy way to back out the
  # changes if something doesn't look right.
  Course.transaction do
    Course.where(archived: false).each do |course|
      puts "Archiving #{course.slug}"

      # first copy the course and instructors and queues
      new_course = course.dup
      course.instructors.each do |i|
        new_course.course_instructors << CourseInstructor.new(course: new_course, instructor: i)
      end
      new_course.course_queues << course.course_queues.collect { |q| q.dup }

      # now archive the old one
      course.update(
        name: "[#{term.upcase}] #{course.name}",
        slug: "#{course.slug}-#{term}",
        archived: true
      )

      # and save the new course
      new_course.save!
    end

    printf "Confirm? "
    ans = STDIN.gets.strip.downcase

    unless ans == 'y' || ans == 'yes'
      puts "Exiting..."
      exit(1)
    end
    puts "Saving..."
  end
end
