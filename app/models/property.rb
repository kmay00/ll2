class Property < ActiveRecord::Base
  has_many :purchases
  has_many :users, through: :purchases


  def self.use_cabybara
    #get leads from Civil Court

    # def use_cabybara
    # Require the gems
    require 'capybara/poltergeist'
    require 'httparty'

    # Configure Poltergeist to not blow up on websites with js errors aka every website with js
    # See more options at https://github.com/teampoltergeist/poltergeist#customization
    Capybara.register_driver :poltergeist do |app|
     Capybara::Poltergeist::Driver.new(app, js_errors: false)
    end

    # Configure Capybara to use Poltergeist as the driver
    Capybara.default_driver = :poltergeist
  end


  def self.get_CSV
    use_cabybara

    # set browser
    browser = Capybara.current_session
    url = "https://officialrecords.broward.org/OncoreV2/search.aspx"
    browser.visit url

    # navigate to url and set search criteria
    browser.click_on('Document Type')
    browser.fill_in('txtDocTypes', :with => 'LP')
    browser.within('#trBeginDate') do
     browser.click_on('Yesterday')
    end
    browser.within('#trEndDate') do
     browser.click_on('Today')
    end

    # click search and wait
    browser.click_on('cmdSubmit')
    sleep 1

    csv_url = browser.current_url

    browser.driver.headers = {
    'Accept-Encoding' => 'gzip, deflate, sdch',
    'Accept-Language' => 'en-US,en;q=0.8',
    'Upgrade-Insecure-Requests' => '1',
    'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.94 Safari/537.36',
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,​*/*​;q=0.8',
    'Connection' => 'keep-alive',
    'Referer' => csv_url,
    'Cookie' => "LastUrl=#{csv_url}; ASP.NET_SessionId=elxjso2ds2nr0s45bfdm1cjp; ImageIdsCookie=DocumentImageIds=106426052; LargeImageValues=DocumentImgIds=106426052&CurrentPageNumber=1&NumberOfImages=1; OnCoreWeb=AutoLoadImages=-1&ImageViewer=2&DefaultNumberOfRows=500&DisablePDFStreaming=False; OnCoreWebAuthenticated=Authenticated=0&AgentKey=-1&CacheKey=70942759.3342"
    }

    download_url = 'https://officialrecords.broward.org/OncoreV2/Export.aspx'
    browser.execute_script("window.downloadCSVXHR = function(){ var url = '#{download_url}'; return getFile(url); }")
    browser.execute_script("window.getFile = function(url) { var xhr = new XMLHttpRequest();  xhr.open('GET', url, false);  xhr.send(null); return xhr.responseText; }")
    data = browser.evaluate_script("downloadCSVXHR()")

    File.write('broward.csv', data)
    data = CSV.read('broward.csv')
    #get rid of the header info
    data.slice!(0)

    ## MAY NOT NEED THIS LINE -- MAY NEED IT?
    # extract_CSV_data(data)


    data.each do |property|
      document_num = property[0]
      owner = property[1]

      # record_date = property[7]
      # record_date = record_date.to_datetime     #.strftime('%Q')
      # p record_date
      # p record_date.class

      doc_number_lp = property[10]

      Partial.create(document_num: document_num,
                      owner: owner,
                      doc_number_lp: doc_number_lp)
    end
  end



  def self.getaddress
    use_cabybara

    Partial.all.each do |item|
      name = item.owner
      document_num = item.document_num
      doc_number_lp = item.doc_number_lp

      browser = Capybara.current_session
      url = 'http://www.bcpa.net/RecName.asp'
      browser.visit url

      browser.find('#Text1').set(name)
      browser.find("a[href='javascript:MM_Edit();']").click

      # IF broswer.page = 'http://www.bcpa.net/RecSearch.asp' THEN skip to next record

      prop_addr = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[1]/tbody/tr/td[1]/table/tbody/tr[1]/td[2]/span')[0].text
      owner = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[1]/tbody/tr/td[1]/table/tbody/tr[2]/td[2]/span')[0].text
      mail_addr = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[1]/tbody/tr/td[1]/table/tbody/tr[3]/td[2]/span')[0].text
      legal_desc = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[3]/tbody/tr/td[2]/span')[0].text
      prop_acct_num = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[1]/tbody/tr/td[3]/table/tbody/tr[1]/td[2]/span')[0].text
      home_value = browser.all(:xpath, '/html/body/table[2]/tbody/tr/td/table/tbody/tr[1]/td[1]/table[5]/tbody/tr[3]/td[4]/span')[0].text

      #go to GeoCodes and get Property Address
      search_addr = prop_addr.gsub(" ","+").gsub("-","+")
      api_key = 'AIzaSyDa1BWxkgm1n3tljbV-J_6bo3r7jV1UsD4'

      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{search_addr}&key=#{api_key}"
      response = HTTParty.get url

      dom = Nokogiri::HTML(response.body)
      parsed = JSON.parse(dom)
      address_components = parsed['results'][0]['address_components']

      prop_str_addr = "#{address_components[0]["long_name"]} #{address_components[1]["long_name"]}"
      prop_city = "#{address_components[3]["long_name"]}"
      prop_state = "#{address_components[5]["short_name"]}"
      prop_zip = "#{address_components[7]["long_name"]}"
      prop_county = "#{address_components[4]["long_name"]}"


      #go back to GeoCodes and get Mailing Address
      search_addr = mail_addr.gsub(" ","+").gsub("-","+")
      api_key = 'AIzaSyDa1BWxkgm1n3tljbV-J_6bo3r7jV1UsD4'

      url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{search_addr}&key=#{api_key}"
      response = HTTParty.get url

      dom = Nokogiri::HTML(response.body)
      parsed = JSON.parse(dom)
      address_components = parsed['results'][0]['address_components']

      mail_str_addr = "#{address_components[0]["long_name"]} #{address_components[1]["long_name"]}"
      mail_city = "#{address_components[3]["long_name"]}"
      mail_state = "#{address_components[5]["short_name"]}"
      mail_zip = "#{address_components[7]["long_name"]}"
      mail_county = "#{address_components[4]["long_name"]}"

      Property.create(owner: name,
                      prop_str_addr: prop_str_addr,
                      prop_city: prop_city,
                      prop_state: prop_state,
                      prop_zip: prop_zip,
                      prop_county: prop_county,
                      mail_str_addr: prop_str_addr,
                      mail_city: prop_city,
                      mail_state: prop_state,
                      mail_zip: prop_zip,
                      mail_county: prop_county,
                      home_value: home_value,
                      legal_desc: legal_desc,
                      document_num: document_num,
                      prop_acct_num: prop_acct_num,
                      doc_number_lp: doc_number_lp
                    )
    end
  end
end
