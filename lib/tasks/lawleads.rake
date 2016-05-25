namespace :lawleads do
  desc "TODO"
  task use_static_csv: :environment do
# $ rake lawleads:use_static_csv

  data = CSV.read('broward-complete.csv')
  #get rid of the header info
  data.slice!(0)

  ## MAY NOT NEED THIS LINE -- MAY NEED IT?
  # extract_CSV_data(data)

  data.each do |property|
    document_num = property[0]
    owner = property[1]

    record_date = property[7]
    record_date = DateTime.strptime(record_date, "%m/%d/%Y %k:%M:%S")
    # record_date = record_date.to_datetime     #.strftime('%Q')
    # p record_date
    # p record_date.class

    doc_number_lp = property[10]

    Partial.create(document_num: document_num,
                    owner: owner,
                    record_date: record_date,
                    doc_number_lp: doc_number_lp)
  end

  end
end
