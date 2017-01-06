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

ActiveRecord::Schema.define(version: 20170106081411) do

  create_table "requests", force: :cascade do |t|
    t.string   "name",                                        null: false
    t.string   "email",                                       null: false
    t.string   "phone_number",                                null: false
    t.text     "paragraph",                                   null: false
    t.boolean  "confirmed",                   default: false, null: false
    t.boolean  "accepted",                    default: false, null: false
    t.boolean  "expired",                     default: false, null: false
    t.date     "accepted_at"
    t.datetime "confirmed_at"
    t.date     "expired_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "confirmation_digest"
    t.boolean  "asked_for_reconfirmation",    default: false
    t.boolean  "reconfirmed",                 default: true
    t.datetime "reconfirmed_at"
    t.datetime "asked_for_reconfirmation_at"
    t.index ["email"], name: "index_requests_on_email", unique: true
  end

end
