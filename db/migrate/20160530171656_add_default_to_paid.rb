class AddDefaultToPaid < ActiveRecord::Migration
  def change
    change_column :purchases, :paid, :boolean, :default => false
  end
end
