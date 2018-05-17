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

ActiveRecord::Schema.define(version: 20180517190607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "player_1_turns", default: 0
    t.integer "player_2_turns", default: 0
    t.integer "current_turn", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_1_id"
    t.bigint "player_2_id"
    t.bigint "winner_id"
    t.bigint "player_1_board_id"
    t.bigint "player_2_board_id"
    t.index ["player_1_board_id"], name: "index_games_on_player_1_board_id"
    t.index ["player_1_id"], name: "index_games_on_player_1_id"
    t.index ["player_2_board_id"], name: "index_games_on_player_2_board_id"
    t.index ["player_2_id"], name: "index_games_on_player_2_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "ships", force: :cascade do |t|
    t.integer "length"
    t.integer "damage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.bigint "board_id"
    t.bigint "ship_id"
    t.index ["board_id"], name: "index_spaces_on_board_id"
    t.index ["ship_id"], name: "index_spaces_on_ship_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "authenticated", default: false
    t.string "api_key"
    t.string "password_digest"
  end

  add_foreign_key "games", "boards", column: "player_1_board_id"
  add_foreign_key "games", "boards", column: "player_2_board_id"
  add_foreign_key "games", "users", column: "player_1_id"
  add_foreign_key "games", "users", column: "player_2_id"
  add_foreign_key "games", "users", column: "winner_id"
  add_foreign_key "spaces", "boards"
  add_foreign_key "spaces", "ships"
end
