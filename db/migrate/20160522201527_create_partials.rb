class CreatePartials < ActiveRecord::Migration
  def change
    create_table :partials do |t|
      t.string :owner
      t.string :prop_str_addr
      t.string :prop_city
      t.string :prop_state
      t.string :prop_zip
      t.string :prop_county
      t.string :mail_str_addr
      t.string :mail_city
      t.string :mail_state
      t.string :mail_zip
      t.string :mail_county
      t.string :home_value
      t.string :prop_acct_num
      t.text :legal_desc
      t.string :document_num
      t.date :record_date
      t.string :doc_number_lp

      t.timestamps null: false
    end
  end
end
