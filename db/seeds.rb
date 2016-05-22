# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

data = CSV.read('broward.csv')
#get rid of the header info
data.slice!(0)

data.each do |property|
  document_num = property[0]
  owner = property[1]
  record_date = property[7]
  doc_number_lp = property[10]

  Property.create(document_num: document_num,
                  owner: owner,
                  record_date: record_date,
                  doc_number_lp: doc_number_lp)
  end
