# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2020_06_09_123208) do
=======
ActiveRecord::Schema.define(version: 2020_06_09_025847) do
>>>>>>> 7e88fd2dda9cd9260e286a3f92b68f30624c0a8d

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "audit_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "model"
    t.string "field_name"
    t.integer "field_id"
    t.string "old_value"
    t.string "new_value"
    t.integer "action"
    t.string "modified_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "location_id"
    t.bigint "slot_id"
    t.bigint "schedule_id"
    t.bigint "clinic_id"
    t.string "reference_code"
    t.string "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "referral_id"
    t.string "referral_code"
    t.integer "booking_type", default: 0
    t.index ["clinic_id"], name: "index_bookings_on_clinic_id"
    t.index ["location_id"], name: "index_bookings_on_location_id"
    t.index ["patient_id"], name: "index_bookings_on_patient_id"
    t.index ["schedule_id"], name: "index_bookings_on_schedule_id"
    t.index ["slot_id"], name: "index_bookings_on_slot_id"
  end

  create_table "clinic_areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "status", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clinics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email_address"
    t.string "contact_number"
    t.text "address"
    t.string "contact_person"
    t.string "billing_code"
    t.boolean "status"
    t.bigint "clinic_area_id"
    t.index ["clinic_area_id"], name: "index_clinics_on_clinic_area_id"
    t.index ["code"], name: "index_clinics_on_code", unique: true
  end

  create_table "location_clinics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "clinic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clinic_id"], name: "index_location_clinics_on_clinic_id"
    t.index ["location_id"], name: "index_location_clinics_on_location_id"
  end

  create_table "locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "longitude"
    t.string "latitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
    t.boolean "status", default: true
    t.integer "referral_type", default: 0
  end

  create_table "patients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "fullname"
    t.string "id_number"
    t.integer "gender_id"
    t.date "date_of_birth"
    t.string "contact_number"
    t.string "email_address"
    t.boolean "q1"
    t.boolean "q2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payment_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "payment_id"
    t.string "trans_id"
    t.string "auth_code"
    t.string "signature"
    t.string "ccname"
    t.string "ccno"
    t.string "s_bankname"
    t.string "s_country"
    t.string "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_reference"
    t.datetime "payment_date"
    t.bigint "payment_mode_id"
    t.string "approved_by"
    t.index ["payment_id"], name: "index_payment_histories_on_payment_id"
    t.index ["payment_mode_id"], name: "index_payment_histories_on_payment_mode_id"
  end

  create_table "payment_modes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "patient_id"
    t.bigint "booking_id"
    t.string "merchant_code"
    t.string "payment_id"
    t.string "ref_no"
    t.string "amount"
    t.string "currency"
    t.text "prod_desc"
    t.string "username"
    t.string "user_email"
    t.string "user_contact"
    t.string "remark"
    t.string "lang"
    t.string "signature_type"
    t.string "signature"
    t.integer "payment_status"
    t.integer "payment_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["patient_id"], name: "index_payments_on_patient_id"
  end

  create_table "profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "contact"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "referrals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "role_policies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "service_id", null: false
    t.bigint "service_policy_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_role_policies_on_service_id"
    t.index ["service_policy_id"], name: "index_role_policies_on_service_policy_id"
    t.index ["user_group_id"], name: "index_role_policies_on_user_group_id"
  end

  create_table "schedules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "location_id"
    t.date "schedule_date"
    t.integer "allocation_per_slot"
    t.integer "minute_interval"
    t.time "morning_start_time"
    t.time "morning_end_time"
    t.time "afternoon_start_time"
    t.time "afternoon_end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "no_of_session"
    t.index ["location_id"], name: "index_schedules_on_location_id"
  end

  create_table "service_policies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.string "name"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["service_id"], name: "index_service_policies_on_service_id"
  end

  create_table "services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.string "resource_path"
    t.string "resource_icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "resource_order"
  end

  create_table "setting_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "setting_id"
    t.bigint "user_id"
    t.string "setting_type"
    t.string "old_value"
    t.string "new_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["setting_id"], name: "index_setting_histories_on_setting_id"
    t.index ["user_id"], name: "index_setting_histories_on_user_id"
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "covid_price", precision: 10, scale: 2
    t.integer "booking_date_range"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "slots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "schedule_id"
    t.time "slot_time"
    t.boolean "status"
    t.integer "allocations"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "meridian"
    t.index ["schedule_id"], name: "index_slots_on_schedule_id"
  end

  create_table "user_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_group_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_group_id"], name: "index_user_roles_on_user_group_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "user_token"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "role_policies", "service_policies"
  add_foreign_key "role_policies", "services"
  add_foreign_key "role_policies", "user_groups"
  add_foreign_key "service_policies", "services"
  add_foreign_key "user_roles", "user_groups"
  add_foreign_key "user_roles", "users"
end
