# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_07_045217) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "band_flyers", force: :cascade do |t|
    t.bigint "band_id", null: false
    t.bigint "flyer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["band_id"], name: "index_band_flyers_on_band_id"
    t.index ["flyer_id"], name: "index_band_flyers_on_flyer_id"
  end

  create_table "bands", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flyers", force: :cascade do |t|
    t.string "title"
    t.date "event_date"
    t.bigint "venue_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venue_id"], name: "index_flyers_on_venue_id"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "band_flyers", "bands"
  add_foreign_key "band_flyers", "flyers"
  add_foreign_key "flyers", "venues"
end
