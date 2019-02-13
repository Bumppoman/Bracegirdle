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

ActiveRecord::Schema.define(version: 2019_02_13_025426) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cemeteries", force: :cascade do |t|
    t.string "name"
    t.integer "county"
    t.integer "order_id"
    t.boolean "active"
    t.date "last_inspection"
    t.date "last_audit"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "cemeteries_towns", id: false, force: :cascade do |t|
    t.integer "cemetery_id"
    t.integer "town_id"
    t.index ["cemetery_id"], name: "index_cemeteries_towns_on_cemetery_id"
    t.index ["town_id"], name: "index_cemeteries_towns_on_town_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.integer "cemetery_id"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "complainant_name"
    t.string "complainant_address"
    t.string "complainant_phone"
    t.string "complainant_email"
    t.string "complaint_type"
    t.string "lot_location"
    t.string "name_on_deed"
    t.string "relationship"
    t.integer "ownership_type"
    t.date "date_of_event"
    t.date "date_complained_to_cemetery"
    t.string "person_contacted"
    t.string "manner_of_contact"
    t.boolean "attorney_contacted", default: false
    t.boolean "court_action_pending", default: false
    t.string "form_of_relief"
    t.integer "receiver_id"
    t.boolean "investigation_required", default: false
    t.integer "investigator_id"
    t.date "investigation_begin_date"
    t.date "investigation_completion_date"
    t.date "disposition_date"
    t.text "disposition"
    t.string "cemetery_alternate_name"
    t.boolean "cemetery_regulated", default: true
    t.integer "status", default: 1
    t.integer "cemetery_county"
    t.string "complaint_number"
    t.date "closure_date"
    t.text "closure_review_comments"
    t.integer "closed_by_id"
    t.index ["cemetery_id"], name: "index_complaints_on_cemetery_id"
    t.index ["closed_by_id"], name: "index_complaints_on_closed_by_id"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "notable_id"
    t.string "notable_type"
    t.integer "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "cemetery_id"
    t.integer "investigator_id"
    t.string "served_on_name"
    t.string "served_on_title"
    t.string "served_on_street_address"
    t.string "served_on_city"
    t.string "served_on_state"
    t.string "served_on_zip"
    t.text "law_sections"
    t.text "specific_information"
    t.date "violation_date"
    t.date "response_required_date"
    t.date "response_received_date"
    t.date "follow_up_inspection_date"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notice_number"
    t.date "notice_resolved_date"
    t.index ["cemetery_id"], name: "index_notices_on_cemetery_id"
    t.index ["investigator_id"], name: "index_notices_on_investigator_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "email"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "rules", force: :cascade do |t|
    t.integer "cemetery_id"
    t.date "submission_date"
    t.date "approval_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.string "sender"
    t.string "sender_email"
    t.string "sender_street_address"
    t.string "sender_city"
    t.string "sender_state"
    t.string "sender_zip"
    t.boolean "request_by_email"
    t.string "identifier"
    t.integer "approved_by_id"
    t.integer "accepted_by_id"
    t.index ["accepted_by_id"], name: "index_rules_on_accepted_by_id"
    t.index ["approved_by_id"], name: "index_rules_on_approved_by_id"
    t.index ["cemetery_id"], name: "index_rules_on_cemetery_id"
  end

  create_table "towns", force: :cascade do |t|
    t.integer "county"
    t.string "name"
  end

  create_table "trustees", force: :cascade do |t|
    t.integer "person_id"
    t.integer "cemetery_id"
    t.integer "position"
    t.index ["cemetery_id"], name: "index_trustees_on_cemetery_id"
    t.index ["person_id"], name: "index_trustees_on_person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.string "title"
    t.string "office_code"
    t.string "street_address"
    t.string "city"
    t.string "zip"
    t.integer "region"
  end

end
