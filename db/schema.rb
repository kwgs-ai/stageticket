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

ActiveRecord::Schema.define(version: 2021_12_13_092108) do

  create_table "actoraccounts", force: :cascade do |t|
    t.string "actor_name", null: false
    t.string "actor_ID", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adminaccounts", force: :cascade do |t|
    t.string "admin_name", null: false
    t.string "admin_ID", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "useraccount_id", null: false
    t.integer "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_reservations_on_stage_id"
    t.index ["useraccount_id"], name: "index_reservations_on_useraccount_id"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "stage_id", null: false
    t.integer "reservation_id"
    t.string "seat_type", null: false
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_seats_on_reservation_id"
    t.index ["stage_id"], name: "index_seats_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.integer "actoraccount_id", null: false
    t.string "status", default: "申請中", null: false
    t.string "title", null: false
    t.string "text", null: false
    t.date "date", null: false
    t.string "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actoraccount_id"], name: "index_stages_on_actoraccount_id"
  end

  create_table "useraccounts", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "user_ID", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
