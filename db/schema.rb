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

ActiveRecord::Schema.define(version: 2020_04_21_100802) do

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
    t.index ["clinic_id"], name: "index_bookings_on_clinic_id"
    t.index ["location_id"], name: "index_bookings_on_location_id"
    t.index ["patient_id"], name: "index_bookings_on_patient_id"
    t.index ["schedule_id"], name: "index_bookings_on_schedule_id"
    t.index ["slot_id"], name: "index_bookings_on_slot_id"
  end

  create_table "clinics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_clinics_on_code", unique: true
  end

  create_table "locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "longitude"
    t.string "latitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["location_id"], name: "index_schedules_on_location_id"
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

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "user_token"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
