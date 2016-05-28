class AddTimestampsToPurchases < ActiveRecord::Migration
  def change
    add_column(:purchases, :created_at, :datetime)
    add_column(:purchases, :updated_at, :datetime)
  end
end
