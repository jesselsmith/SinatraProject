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

ActiveRecord::Schema.define(version: 2019_12_05_193353) do

  create_table "adventure_logs", force: :cascade do |t|
    t.string "adventure_name"
    t.string "dm_name"
    t.string "dm_dci"
    t.integer "gold_change"
    t.integer "downtime_change"
    t.string "notes"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_played"
    t.boolean "level_up"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.integer "gold"
    t.integer "downtime"
    t.string "faction"
    t.boolean "adventurers_league"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "character_class"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "dci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
