class CreateStructure < ActiveRecord::Migration
  def change
    create_table "partials", force: :cascade do |t|
      t.string   "owner"
      t.string   "prop_str_addr"
      t.string   "prop_city"
      t.string   "prop_zip"
      t.string   "prop_state"
      t.integer  "home_value"
      t.string   "prop_acct_num"
      t.text     "legal_desc"
      t.string   "mail_str_addr"
      t.string   "mail_city"
      t.string   "mail_zip"
      t.string   "mail_state"
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
      t.string   "document_num"
      t.date     "record_date"
      t.string   "doc_number_lp"
      t.string   "prop_county"
      t.string   "mail_county"
    end

    create_table "properties", force: :cascade do |t|
      t.string   "owner"
      t.string   "prop_str_addr"
      t.string   "prop_city"
      t.string   "prop_zip"
      t.integer  "home_value"
      t.string   "prop_acct_num"
      t.text     "legal_desc"
      t.string   "mail_str_addr"
      t.string   "mail_city"
      t.string   "mail_zip"
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
      t.string   "prop_state"
      t.string   "mail_state"
      t.string   "document_num"
      t.date     "record_date"
      t.string   "doc_number_lp"
      t.string   "prop_county"
      t.string   "mail_county"
    end

    create_table "purchases", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "property_id"
    end

    create_table "users", force: :cascade do |t|
      t.string   "company_name"
      t.string   "user_name"
      t.string   "email"
      t.string   "phone"
      t.string   "password_digest"
      t.string   "street_addr"
      t.string   "city"
      t.string   "zip"
      t.string   "biz_type"
      t.datetime "created_at",      null: false
      t.datetime "updated_at",      null: false
    end

  end
end
