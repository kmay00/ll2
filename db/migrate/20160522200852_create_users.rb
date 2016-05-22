class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :company_name
      t.string :user_name
      t.string :email
      t.string :phone
      t.string :street_addr
      t.string :city
      t.string :zip
      t.string :biz_type

      t.timestamps null: false
    end
  end
end
