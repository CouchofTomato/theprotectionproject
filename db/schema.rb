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

ActiveRecord::Schema.define(version: 2021_08_06_174318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefits", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "category"], name: "index_benefits_on_name_and_category", unique: true
  end

  create_table "coverage_areas", force: :cascade do |t|
    t.integer "category", null: false
    t.bigint "product_module_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category", "product_module_id"], name: "index_coverage_areas_on_category_and_product_module", unique: true
    t.index ["product_module_id"], name: "index_coverage_areas_on_product_module_id"
  end

  create_table "insurers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_insurers_on_name", unique: true
  end

  create_table "linked_product_modules", force: :cascade do |t|
    t.bigint "product_module_id", null: false
    t.bigint "linked_module_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["linked_module_id"], name: "index_linked_product_modules_on_linked_module_id"
    t.index ["product_module_id"], name: "index_linked_product_modules_on_product_module_id"
  end

  create_table "product_module_benefits", force: :cascade do |t|
    t.bigint "product_module_id", null: false
    t.bigint "benefit_id", null: false
    t.integer "benefit_status", null: false
    t.string "benefit_limit", null: false
    t.text "explanation_of_benefit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "benefit_weighting", default: 0
    t.index ["benefit_id"], name: "index_product_module_benefits_on_benefit_id"
    t.index ["product_module_id", "benefit_id"], name: "index_product_module_benefits_on_product_module_and_benefit", unique: true
    t.index ["product_module_id"], name: "index_product_module_benefits_on_product_module_id"
  end

  create_table "product_modules", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category", null: false
    t.string "sum_assured", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "category", "product_id"], name: "index_product_modules_on_name_and_category_and_product_id", unique: true
    t.index ["product_id"], name: "index_product_modules_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "insurer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_type"
    t.integer "minimum_applicant_age", null: false
    t.integer "maximum_applicant_age", null: false
    t.index ["insurer_id"], name: "index_products_on_insurer_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coverage_areas", "product_modules"
  add_foreign_key "linked_product_modules", "product_modules"
  add_foreign_key "linked_product_modules", "product_modules", column: "linked_module_id"
  add_foreign_key "product_module_benefits", "benefits"
  add_foreign_key "product_module_benefits", "product_modules"
  add_foreign_key "product_modules", "products"
  add_foreign_key "products", "insurers"
end
