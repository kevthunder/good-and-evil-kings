# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140312222815) do

  create_table "actions", force: true do |t|
    t.datetime "time"
    t.integer  "actionnable_id"
    t.string   "actionnable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["actionnable_id", "actionnable_type"], name: "index_actions_on_actionnable_id_and_actionnable_type"

  create_table "castles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kingdom_id"
  end

  add_index "castles", ["kingdom_id"], name: "index_castles_on_kingdom_id"

  create_table "garrisons", force: true do |t|
    t.integer  "qte"
    t.integer  "kingdom_id"
    t.integer  "soldier_type_id"
    t.integer  "garrisonable_id"
    t.string   "garrisonable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "garrisons", ["garrisonable_id", "garrisonable_type"], name: "index_garrisons_on_garrisonable_id_and_garrisonable_type"
  add_index "garrisons", ["kingdom_id"], name: "index_garrisons_on_kingdom_id"
  add_index "garrisons", ["soldier_type_id"], name: "index_garrisons_on_soldier_type_id"

  create_table "kingdoms", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "karma"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kingdoms", ["user_id"], name: "index_kingdoms_on_user_id"

  create_table "mission_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mission_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "behavior"
  end

  create_table "missions", force: true do |t|
    t.integer  "mission_type_id"
    t.integer  "mission_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "castle_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "next_event"
  end

  add_index "missions", ["castle_id"], name: "index_missions_on_castle_id"
  add_index "missions", ["mission_status_id"], name: "index_missions_on_mission_status_id"
  add_index "missions", ["mission_type_id"], name: "index_missions_on_mission_type_id"
  add_index "missions", ["target_id", "target_type"], name: "index_missions_on_target_id_and_target_type"

  create_table "movements", force: true do |t|
    t.datetime "start_time"
    t.integer  "start_tile_id"
    t.integer  "end_tile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mission_id"
  end

  add_index "movements", ["end_tile_id"], name: "index_movements_on_end_tile_id"
  add_index "movements", ["mission_id"], name: "index_movements_on_mission_id"
  add_index "movements", ["start_tile_id"], name: "index_movements_on_start_tile_id"

  create_table "ressources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "soldier_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks", force: true do |t|
    t.integer  "qte"
    t.integer  "ressource_id"
    t.integer  "stockable_id"
    t.string   "stockable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["ressource_id"], name: "index_stocks_on_ressource_id"
  add_index "stocks", ["stockable_id", "stockable_type"], name: "index_stocks_on_stockable_id_and_stockable_type"

  create_table "tiles", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tiled_id"
    t.string   "tiled_type"
  end

  add_index "tiles", ["tiled_id", "tiled_type"], name: "index_tiles_on_tiled_id_and_tiled_type"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
