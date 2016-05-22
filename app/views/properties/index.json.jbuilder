json.array!(@properties) do |property|
  json.extract! property, :id, :owner, :prop_str_addr, :prop_city, :prop_state, :prop_zip, :prop_county, :mail_str_addr, :mail_city, :mail_state, :mail_zip, :mail_county, :home_value, :prop_acct_num, :legal_desc, :document_num, :record_date, :doc_number_lp
  json.url property_url(property, format: :json)
end
