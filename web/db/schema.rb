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

ActiveRecord::Schema.define(version: 20140827165010) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.integer  "region_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["region_id"], name: "index_cities_on_region_id"

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "eventos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "publicador_id"
    t.string   "name"
    t.string   "subtitle"
    t.string   "address"
    t.string   "information"
    t.string   "coordinates"
    t.integer  "organization_id"
    t.integer  "category_id"
    t.integer  "city_id"
    t.integer  "region_id"
  end

  add_index "eventos", ["publicador_id"], name: "index_eventos_on_publicador_id"

  create_table "oferta", force: true do |t|
    t.string   "nombre"
    t.string   "desc"
    t.integer  "porcentaje"
    t.boolean  "mod_cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "contact_person"
    t.string   "phone"
    t.boolean  "valid"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "pasajes", force: true do |t|
    t.integer  "user_evento_id"
    t.integer  "oferta_id"
    t.integer  "precio"
    t.integer  "cantidad"
    t.string   "codigo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pasajes", ["oferta_id"], name: "index_pasajes_on_oferta_id"
  add_index "pasajes", ["user_evento_id"], name: "index_pasajes_on_user_evento_id"

  create_table "publicacion_carpools", force: true do |t|
    t.integer  "user_evento_id"
    t.date     "fecha"
    t.text     "descripcion"
    t.time     "hora_desde"
    t.string   "desde"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asientos_disp"
    t.string   "tipo_vehiculo"
    t.string   "celular"
  end

  create_table "publicadors", force: true do |t|
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
    t.string   "username"
  end

  add_index "publicadors", ["email"], name: "index_publicadors_on_email", unique: true
  add_index "publicadors", ["reset_password_token"], name: "index_publicadors_on_reset_password_token", unique: true
  add_index "publicadors", ["username"], name: "index_publicadors_on_username", unique: true

  create_table "red_socials", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "red_socials", ["user_id"], name: "index_red_socials_on_user_id"

  create_table "regions", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_eventos", force: true do |t|
    t.integer  "user_id"
    t.integer  "evento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "nombre"
    t.string   "ciudad"
    t.string   "region"
    t.string   "telefono"
    t.date     "cumple"
    t.string   "rut"
    t.string   "dv"
    t.text     "direccion"
    t.string   "foto"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
