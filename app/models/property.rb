class Property < ActiveRecord::Base
  has_many :purchases
  has_many :users, through: :purchases

  def self.search(keywords)

    # set defaults here?
    #
    # lower_bound = keywords[:keyword1] || 50000
    # upper_bound = keywords[:keyword2] || 10000000
    #
    #
    # Below -- syntax examples
    #
    # userid = opts[:userid] || 'a_default_userid'
    # password = opts[:password] ||'a_default_password'


    if keywords[:keyword2].blank?
      # if the upper bound is a blank - Hard Code an upper bound value (maybe Property.max)
      where("home_value >= ? AND home_value <= ?", keywords[:keyword1], keywords[:keyword2])
    else
      # no blank upper bound
      where("home_value >= ? AND home_value <= ?", keywords[:keyword1], keywords[:keyword2])
    end
  end

end
