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

ActiveRecord::Schema.define(version: 20151021202527) do

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "compare_budgets_expenses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "program_id",       limit: 4
    t.string   "document_number",  limit: 255
    t.date     "payment_date"
    t.decimal  "value",                        precision: 10
    t.integer  "type_expense_id",  limit: 4
    t.integer  "company_id",       limit: 4
    t.integer  "function_id",      limit: 4
    t.integer  "public_agency_id", limit: 4
  end

  add_index "expenses", ["company_id"], name: "index_expenses_on_company_id", using: :btree
  add_index "expenses", ["function_id"], name: "index_expenses_on_function_id", using: :btree
  add_index "expenses", ["program_id"], name: "index_expenses_on_program_id", using: :btree
  add_index "expenses", ["public_agency_id"], name: "index_expenses_on_public_agency_id", using: :btree
  add_index "expenses", ["type_expense_id"], name: "index_expenses_on_type_expense_id", using: :btree

  create_table "functions", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
  end

  create_table "public_agencies", force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "superior_public_agency_id", limit: 4
    t.string   "name",                      limit: 255
    t.integer  "views_amount",              limit: 4
  end

  add_index "public_agencies", ["superior_public_agency_id"], name: "index_public_agencies_on_superior_public_agency_id", using: :btree

  create_table "superior_public_agencies", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name",       limit: 255
  end

  create_table "type_expenses", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_foreign_key "expenses", "companies"
  add_foreign_key "expenses", "functions"
  add_foreign_key "expenses", "programs"
  add_foreign_key "expenses", "public_agencies"
  add_foreign_key "expenses", "type_expenses"
  add_foreign_key "public_agencies", "superior_public_agencies"
end
