# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141215123452) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

  create_table "assignfiles", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "description"
    t.datetime "due_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "open_at"
  end

  create_table "course_user_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_user_relationships", ["course_id"], name: "index_course_user_relationships_on_course_id"
  add_index "course_user_relationships", ["user_id", "course_id"], name: "index_course_user_relationships_on_user_id_and_course_id", unique: true
  add_index "course_user_relationships", ["user_id"], name: "index_course_user_relationships_on_user_id"

  create_table "courses", force: true do |t|
    t.integer  "department_id"
    t.string   "full_name"
    t.string   "english_name"
    t.string   "description"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "folders", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.boolean  "is_doc"
    t.boolean  "is_assignment"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.integer  "weight"
    t.integer  "father_id"
    t.integer  "course_id"
    t.integer  "child_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.integer  "father_id"
    t.integer  "course_id"
    t.integer  "child_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.boolean  "unread",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id"

  create_table "permissions", force: true do |t|
    t.integer  "folder_id"
    t.integer  "group_id"
    t.boolean  "can_create"
    t.boolean  "can_read"
    t.boolean  "can_update"
    t.boolean  "can_delete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "source"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "share_links", force: true do |t|
    t.string   "emails"
    t.string   "link_token"
    t.datetime "link_expires_at"
    t.integer  "user_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.integer  "user_id"
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "replies_count"
    t.datetime "replied_at"
    t.text     "source"
    t.text     "body"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  create_table "user_files", force: true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.string   "attachment_fingerprint"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reference_count"
  end

  create_table "users", force: true do |t|
    t.string   "realname"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "remember_token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_admin"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.string   "signup_token"
    t.string   "signup_token_expires_at"
    t.string   "preferred_lang"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "values", force: true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
