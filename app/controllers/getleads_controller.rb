class GetleadsController < ApplicationController
  def index
    #get leads from Civil Court

    data = CSV.read('broward.csv')
    #get rid of the header info
    data.slice!(0)

    data.each do |property|
      document_num = property[0]
      owner = property[1]
      # record_date = property[7]
      # record_date = record_date.to_datetime.strftime('%Q')
      # p record_date
      # p record_date.class
      doc_number_lp = property[10]

      Partial.create(document_num: document_num,
                      owner: owner,
                      doc_number_lp: doc_number_lp)
      end
  end
end
