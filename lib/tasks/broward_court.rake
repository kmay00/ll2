namespace :broward_court do
  desc "TODO"
  task get_lis_pendens: :environment do
  # $ rake broward_court:get_lis_pendens  

  def use_cabybara
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
end
