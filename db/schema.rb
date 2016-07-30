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

ActiveRecord::Schema.define(version: 20160730072604) do

  create_table "sentinel_data", force: :cascade do |t|
    t.decimal  "latitude",    precision: 10, scale: 7
    t.decimal  "longitude",   precision: 10, scale: 7
    t.decimal  "sh",          precision: 4,  scale: 3
    t.decimal  "sl",          precision: 4,  scale: 3
    t.decimal  "power",       precision: 3,  scale: 1
    t.integer  "confidence"
    t.datetime "datetime"
    t.string   "offset"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "temp_kelvin", precision: 4,  scale: 1
    t.string   "sentinel_id"
  end

end
