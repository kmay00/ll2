namespace :assessor_bug do
  desc "TODO"
  task drop_into_pry: :environment do

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

    name = 'STEWART,BALDWIN'

    browser = Capybara.current_session
    url = 'http://www.bcpa.net/RecName.asp'
    browser.visit url

    browser.find('#Text1').set(name)
    browser.find("a[href='javascript:MM_Edit();']").click

    require "pry"
    binding.pry


  end

end
