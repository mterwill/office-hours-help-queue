# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_05_19_123402) do

  create_table "course_group_students", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "course_group_id", null: false
    t.integer "student_id", null: false
    t.index ["student_id", "course_group_id"], name: "index_course_group_students_on_student_id_and_course_group_id", unique: true
    t.index ["student_id"], name: "index_course_group_students_on_student_id"
  end

  create_table "course_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_groups_on_course_id"
  end

  create_table "course_instructors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "instructor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "instructor_id"], name: "index_course_instructors_on_course_id_and_instructor_id", unique: true
  end

  create_table "course_queue_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "requester_id", null: false
    t.integer "course_queue_id", null: false
    t.text "description"
    t.integer "resolver_id"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.integer "course_group_id"
    t.index ["course_queue_id"], name: "index_course_queue_entries_on_course_queue_id"
  end

  create_table "course_queue_online_instructors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "course_queue_id", null: false
    t.integer "online_instructor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_queue_id"], name: "index_course_queue_online_instructors_on_course_queue_id"
  end

  create_table "course_queues", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.text "description"
    t.boolean "is_open"
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "group_mode", default: false, null: false
    t.text "instructor_message"
    t.boolean "exclusive", default: false, null: false
    t.boolean "hide_details_from_students", default: false, null: false
    t.boolean "add_requested_at_jitter", default: false, null: false
    t.index ["course_id", "name"], name: "index_course_queues_on_course_id_and_name", unique: true
  end

  create_table "courses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "long_name", null: false
    t.string "slug", null: false
    t.boolean "archived", default: false, null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.string "provider"
    t.string "avatar_url", limit: 1000
    t.boolean "global_admin"
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
