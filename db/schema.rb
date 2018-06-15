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

ActiveRecord::Schema.define(version: 2018_06_06_111720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "curated_links", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "keywords"
    t.datetime "destroyed_at"
  end

  create_table "foi_requests", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "contact_id"
    t.bigint "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_foi_requests_on_contact_id"
    t.index ["submission_id"], name: "index_foi_requests_on_submission_id"
  end

  create_table "foi_suggestions", force: :cascade do |t|
    t.bigint "foi_request_id"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "request_matches"
    t.decimal "relevance", precision: 7, scale: 6
    t.integer "clicks", default: 0, null: false
    t.integer "submissions", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["foi_request_id"], name: "index_foi_suggestions_on_foi_request_id"
    t.index ["resource_type", "resource_id"], name: "index_foi_suggestions_on_resource_type_and_resource_id"
  end

  create_table "published_requests", force: :cascade do |t|
    t.jsonb "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "url"
    t.text "summary"
    t.string "keywords"
    t.string "reference"
  end

  create_table "submissions", force: :cascade do |t|
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
    t.string "job_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "foi_requests", "contacts"
  add_foreign_key "foi_requests", "submissions"
end
