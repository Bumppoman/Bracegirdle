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

ActiveRecord::Schema.define(version: 2019_05_01_230122) do

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

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.string "object_type"
    t.integer "object_id"
    t.string "activity_performed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.integer "cemetery_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
    t.index ["cemetery_id"], name: "index_attachments_on_cemetery_id"
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "cemeteries", force: :cascade do |t|
    t.string "name"
    t.integer "county"
    t.integer "order_id"
    t.boolean "active", default: true
    t.date "last_inspection_date"
    t.date "last_audit"
  end

  create_table "cemeteries_towns", id: false, force: :cascade do |t|
    t.integer "cemetery_id"
    t.integer "town_id"
    t.index ["cemetery_id"], name: "index_cemeteries_towns_on_cemetery_id"
    t.index ["town_id"], name: "index_cemeteries_towns_on_town_id"
  end

  create_table "cemetery_inspections", force: :cascade do |t|
    t.integer "cemetery_id"
    t.integer "investigator_id"
    t.date "date_performed"
    t.integer "status", default: 1
    t.string "trustee_name"
    t.integer "trustee_position"
    t.string "trustee_street_address"
    t.string "trustee_city"
    t.string "trustee_state"
    t.string "trustee_zip"
    t.string "trustee_phone"
    t.string "trustee_email"
    t.boolean "sign"
    t.string "identifier"
    t.text "cemetery_location"
    t.string "cemetery_sign_text"
    t.string "sign_comments"
    t.boolean "offices"
    t.string "offices_comments"
    t.boolean "rules_displayed"
    t.string "rules_displayed_comments"
    t.boolean "prices_displayed"
    t.string "prices_displayed_comments"
    t.boolean "scattering_gardens"
    t.string "scattering_gardens_comments"
    t.boolean "community_mausoleum"
    t.string "community_mausoleum_comments"
    t.boolean "winter_burials"
    t.string "winter_burials_comments"
    t.boolean "private_mausoleum"
    t.string "private_mausoleum_comments"
    t.boolean "lawn_crypts"
    t.string "lawn_crypts_comments"
    t.boolean "grave_liners"
    t.string "grave_liners_comments"
    t.boolean "sale_of_monuments"
    t.string "sale_of_monuments_comments"
    t.boolean "fencing"
    t.string "fencing_comments"
    t.text "main_road"
    t.text "side_roads"
    t.text "new_memorials"
    t.text "old_memorials"
    t.text "vandalism"
    t.text "hazardous_materials"
    t.boolean "receiving_vault_exists"
    t.boolean "receiving_vault_inspected"
    t.string "receiving_vault_bodies"
    t.boolean "receiving_vault_clean"
    t.boolean "receiving_vault_obscured"
    t.boolean "receiving_vault_exclusive"
    t.boolean "receiving_vault_secured"
    t.text "overall_conditions"
    t.text "renovations"
    t.boolean "annual_meetings"
    t.string "annual_meetings_comments"
    t.string "election"
    t.integer "number_of_trustees"
    t.boolean "burial_permits"
    t.string "burial_permits_comments"
    t.boolean "body_delivery_receipt"
    t.string "body_delivery_receipt_comments"
    t.boolean "deeds_signed"
    t.string "deeds_signed_comments"
    t.boolean "burial_records"
    t.string "burial_records_comments"
    t.boolean "rules_provided"
    t.string "rules_provided_comments"
    t.boolean "rules_approved"
    t.string "rules_approved_comments"
    t.boolean "employees"
    t.string "employees_comments"
    t.boolean "trustees_compensated"
    t.string "trustees_compensated_comments"
    t.index ["cemetery_id"], name: "index_cemetery_inspections_on_cemetery_id"
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

  create_table "contractors", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
  end

  create_table "estimates", force: :cascade do |t|
    t.integer "restoration_id"
    t.integer "contractor_id"
    t.decimal "amount", precision: 9, scale: 2
    t.integer "warranty"
    t.boolean "proper_format"
    t.index ["restoration_id"], name: "index_estimates_on_restoration_id"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "locatable_id"
    t.string "locatable_type"
    t.float "latitude"
    t.float "longitude"
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

  create_table "notifications", force: :cascade do |t|
    t.integer "receiver_id"
    t.integer "sender_id"
    t.string "object_type"
    t.integer "object_id"
    t.string "message"
    t.text "custom_body"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_notifications_on_receiver_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
  end

  create_table "restoration", force: :cascade do |t|
    t.integer "application_type"
    t.integer "cemetery_id"
    t.integer "trustee_id"
    t.decimal "amount", precision: 9, scale: 2
    t.date "submission_date"
    t.date "field_visit_date"
    t.date "recommendation_date"
    t.date "supervisor_review_date"
    t.date "award_date"
    t.date "completion_date"
    t.date "follow_up_date"
    t.integer "status", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "investigator_id"
    t.string "identifier"
    t.integer "monuments"
    t.boolean "application_form_complete", default: false
    t.decimal "legal_notice_cost", precision: 9, scale: 2
    t.text "legal_notice_newspaper"
    t.boolean "legal_notice_format", default: false
    t.boolean "previous_exists"
    t.integer "previous_type"
    t.string "previous_date"
    t.integer "reviewer_id"
    t.index ["cemetery_id"], name: "index_restoration_on_cemetery_id"
    t.index ["investigator_id"], name: "index_restoration_on_investigator_id"
    t.index ["reviewer_id"], name: "index_restoration_on_reviewer_id"
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
    t.integer "investigator_id"
    t.date "revision_request_date"
    t.index ["cemetery_id"], name: "index_rules_on_cemetery_id"
    t.index ["investigator_id"], name: "index_rules_on_investigator_id"
  end

  create_table "towns", force: :cascade do |t|
    t.integer "county"
    t.string "name"
  end

  create_table "trustees", force: :cascade do |t|
    t.integer "cemetery_id"
    t.integer "position"
    t.string "name"
    t.string "street_address"
    t.string "phone"
    t.string "email"
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.index ["cemetery_id"], name: "index_trustees_on_cemetery_id"
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
