namespace :fix_address do
  desc "TODO"
  task geocodes: :environment do

    # $ rake fix_address:geocodes

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
        address_components = parsed['results'][0]['formatted_address']

        prop_str_addr = address_components.split(",")[0].strip
        prop_city = address_components(",")[1].strip
        prop_state = address_components.split(",")[2](" ")[0].strip
        prop_zip = address_components.split(",")[2](" ")[1].strip
        # Use GoogleGeoCodes PlaceID finder to find additional info such as County
        # prop_county = "#{address_components[4]["long_name"]}"


        #go back to GeoCodes and get Mailing Address
        search_addr = mail_addr.gsub(" ","+").gsub("-","+")
        api_key = 'AIzaSyDa1BWxkgm1n3tljbV-J_6bo3r7jV1UsD4'

        url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{search_addr}&key=#{api_key}"
        response = HTTParty.get url

        dom = Nokogiri::HTML(response.body)
        parsed = JSON.parse(dom)
        address_components = parsed['results'][0]['formatted_address']

        mail_str_addr = address_components.split(",")[0].strip
        mail_city = address_components(",")[1].strip
        mail_state = address_components.split(",")[2](" ")[0].strip
        mail_zip = address_components.split(",")[2](" ")[1].strip
        # Use GoogleGeoCodes PlaceID finder to find additional info such as County
        # mail_county = "#{address_components[4]["long_name"]}"

        Property.create(owner: name,
                        prop_str_addr: prop_str_addr,
                        prop_city: prop_city,
                        prop_state: prop_state,
                        prop_zip: prop_zip,
                        # prop_county: prop_county,
                        mail_str_addr: prop_str_addr,
                        mail_city: prop_city,
                        mail_state: prop_state,
                        mail_zip: prop_zip,
                        # mail_county: prop_county,
                        home_value: home_value,
                        legal_desc: legal_desc,
                        document_num: document_num,
                        prop_acct_num: prop_acct_num,
                        doc_number_lp: doc_number_lp
                      )
      end

  end
end
