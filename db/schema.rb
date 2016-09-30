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

ActiveRecord::Schema.define(version: 20160930183807) do

  create_table "course_instructors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "course_id",     null: false
    t.integer  "instructor_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["course_id", "instructor_id"], name: "index_course_instructors_on_course_id_and_instructor_id", unique: true, using: :btree
  end

  create_table "course_queue_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "requester_id",                  null: false
    t.integer  "course_queue_id",               null: false
    t.text     "description",     limit: 65535
    t.integer  "resolver_id"
    t.datetime "resolved_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "location"
    t.index ["course_queue_id"], name: "index_course_queue_entries_on_course_queue_id", using: :btree
  end

  create_table "course_queue_online_instructors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "course_queue_id",      null: false
    t.integer  "online_instructor_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["course_queue_id"], name: "index_course_queue_online_instructors_on_course_queue_id", using: :btree
  end

  create_table "course_queues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                      null: false
    t.string   "location"
    t.text     "description", limit: 65535
    t.boolean  "is_open"
    t.integer  "course_id",                 null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["course_id", "name"], name: "index_course_queues_on_course_id_and_name", unique: true, using: :btree
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "long_name",  null: false
    t.string   "slug",       null: false
    t.index ["name"], name: "index_courses_on_name", unique: true, using: :btree
    t.index ["slug"], name: "index_courses_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email",            null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "provider"
    t.string   "avatar_url"
    t.boolean  "global_admin"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
