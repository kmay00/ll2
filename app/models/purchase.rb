class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :property

  def self.to_csv(options = {})     # add xls option by adding (options = {})
    column_names = []
    CSV.generate(options) do |csv|  # add xls option by adding (options)
      column_names << 'owner' << 'prop str addr' << 'prop city' << 'prop state' << 'prop zip' << 'home value' << 'record date'
      csv << column_names
      # csv.add_row column_names
      all.each do |item|
        row = []
        row << item.property.owner
        row << item.property.prop_str_addr
        row << item.property.prop_city
        row << item.property.prop_state
        row << item.property.prop_zip
        row << item.property.home_value
        row << item.property.record_date
        csv << row
        # p item.property.owner
      end
    end
  end
end

# csv << column_names
# all.each do |item|
#   csv << item.attributes.values_at(*column_names)

# names = column_names << 'owner'
# csv << names
# all.each do |item|
#   row = item.attributes.values_at(*column_names)
#   row << Property.find_by(id: bought).owner
#   csv << row
