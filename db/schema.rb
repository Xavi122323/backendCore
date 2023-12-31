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

ActiveRecord::Schema[7.0].define(version: 2023_12_30_174850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "componentes", force: :cascade do |t|
    t.integer "nroCPU"
    t.integer "memoria"
    t.integer "almacenamiento"
    t.bigint "servidor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servidor_id"], name: "index_componentes_on_servidor_id"
  end

  create_table "databases", force: :cascade do |t|
    t.string "nombre"
    t.bigint "servidor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transacciones"
    t.date "fechaTransaccion"
    t.index ["servidor_id"], name: "index_databases_on_servidor_id"
  end

  create_table "metricas", force: :cascade do |t|
    t.float "usoCPU"
    t.float "usoMemoria"
    t.float "usoAlmacenamiento"
    t.datetime "fechaRecoleccion", precision: 0
    t.bigint "servidor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servidor_id"], name: "index_metricas_on_servidor_id"
  end

  create_table "servidors", force: :cascade do |t|
    t.string "nombre"
    t.string "direccionIP"
    t.string "SO"
    t.string "motorBase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "componentes", "servidors"
  add_foreign_key "databases", "servidors"
  add_foreign_key "metricas", "servidors"
end
