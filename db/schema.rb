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

ActiveRecord::Schema.define(version: 20140724234036) do

  create_table "actions", force: true do |t|
    t.datetime "time"
    t.integer  "actionnable_id"
    t.string   "actionnable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actions", ["actionnable_id", "actionnable_type"], name: "index_actions_on_actionnable_id_and_actionnable_type"

  create_table "ai_actions", force: true do |t|
    t.string   "type"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ais", force: true do |t|
    t.integer  "castle_id"
    t.datetime "next_action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ais", ["castle_id"], name: "index_ais_on_castle_id"

  create_table "building_types", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "build_time"
    t.integer  "size_x"
    t.integer  "size_y"
  end

  create_table "buildings", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.integer  "building_type_id"
    t.integer  "castle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ready"
  end

  add_index "buildings", ["building_type_id"], name: "index_buildings_on_building_type_id"
  add_index "buildings", ["castle_id"], name: "index_buildings_on_castle_id"

  create_table "castles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kingdom_id"
    t.string   "elevations_map"
    t.datetime "incomes_date"
    t.integer  "max_stock"
    t.integer  "pop"
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
    t.datetime "ready"
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

  create_table "mission_lengths", force: true do |t|
    t.string   "label"
    t.integer  "seconds"
    t.float    "reward"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mission_lengths", ["target_id", "target_type"], name: "index_mission_lengths_on_target_id_and_target_type"

  create_table "mission_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "mission_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "class_name"
  end

  create_table "missions", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "castle_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "next_event"
    t.string   "type"
    t.string   "mission_status_code"
  end

  add_index "missions", ["castle_id"], name: "index_missions_on_castle_id"
  add_index "missions", ["mission_status_code"], name: "index_missions_on_mission_status_code"
  add_index "missions", ["target_id", "target_type"], name: "index_missions_on_target_id_and_target_type"

  create_table "modifications", force: true do |t|
    t.integer  "modificator_id"
    t.integer  "modifiable_id"
    t.string   "modifiable_type"
    t.integer  "applier_id"
    t.string   "applier_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modifications", ["applier_id", "applier_type"], name: "index_modifications_on_applier_id_and_applier_type"
  add_index "modifications", ["modifiable_id", "modifiable_type"], name: "index_modifications_on_modifiable_id_and_modifiable_type"
  add_index "modifications", ["modificator_id"], name: "index_modifications_on_modificator_id"

  create_table "modificators", force: true do |t|
    t.string   "prop"
    t.float    "num"
    t.boolean  "multiply",        default: false, null: false
    t.integer  "modifiable_id"
    t.string   "modifiable_type"
    t.integer  "applier_id"
    t.string   "applier_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modificators", ["applier_id", "applier_type"], name: "index_modificators_on_applier_id_and_applier_type"
  add_index "modificators", ["modifiable_id", "modifiable_type"], name: "index_modificators_on_modifiable_id_and_modifiable_type"

  create_table "movements", force: true do |t|
    t.datetime "start_time"
    t.integer  "start_tile_id"
    t.integer  "end_tile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mission_id"
    t.datetime "end_time"
  end

  add_index "movements", ["end_tile_id"], name: "index_movements_on_end_tile_id"
  add_index "movements", ["mission_id"], name: "index_movements_on_mission_id"
  add_index "movements", ["start_tile_id"], name: "index_movements_on_start_tile_id"

  create_table "options", force: true do |t|
    t.string   "name"
    t.string   "val"
    t.integer  "target_id"
    t.string   "target_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["target_id", "target_type"], name: "index_options_on_target_id_and_target_type"

  create_table "ressources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "global"
  end

  create_table "soldier_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "speed"
    t.integer  "attack"
    t.integer  "defence"
    t.integer  "interception"
    t.integer  "carry"
    t.integer  "recrute_time"
    t.boolean  "military"
    t.string   "machine_name"
  end

  create_table "stocks", force: true do |t|
    t.integer  "qte"
    t.integer  "ressource_id"
    t.integer  "stockable_id"
    t.string   "stockable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.datetime "breakpoint_time"
  end

  add_index "stocks", ["ressource_id"], name: "index_stocks_on_ressource_id"
  add_index "stocks", ["stockable_id", "stockable_type"], name: "index_stocks_on_stockable_id_and_stockable_type"
  add_index "stocks", ["type"], name: "index_stocks_on_type"

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
