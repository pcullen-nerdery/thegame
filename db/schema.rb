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

ActiveRecord::Schema.define(version: 20160708234518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "effects", force: :cascade do |t|
    t.datetime "occurred_at"
    t.string   "creator"
    t.string   "target"
    t.string   "name"
    t.string   "effect_type"
    t.integer  "vote_gain"
    t.string   "description"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "fingerprint"
    t.string   "status"
    t.index ["fingerprint"], name: "index_effects_on_fingerprint", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.string   "guid"
    t.string   "name"
    t.integer  "rarity"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "status"
  end

  create_table "persisted_values", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "value_datetime"
  end

  create_table "queued_items", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "status"
    t.integer  "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "target"
  end

end
