class DashboardController < ApplicationController

  def index
    @properties = Property.all
  end

  def create
    @properties = Property.all
  end

  def show
    @properties = Property.all
    # setting purchase to all purchases by currently logged in user
    @purchases = Purchase.where(user_id: session[:user_id])
    # @bought = []
    respond_to do |format|
      format.html
      format.csv { send_data @purchases.to_csv }
      # format.xls { send_data @purchases.to_csv(col_sep: "\t") }
    end
  end

  def just_bought
    @properties = Property.all
    @purchases = Purchase.all
  end

  def stripe
    @purchases = Purchase.where(user_id: session[:user_id], paid: false)

    # puts all user purchases into an array
    # @user_purchases = User.where(user_id: session[:user_id])

    # then need to change 'paid' by accessing through user_purchases
    # and iterate through using @user_purchases
    # user_purchases.find_by(property_id)
  end

  def avail_to_buy
    # LOGIC to only display Properties not yet purchased
    #
    # set var = attorney to current session user
    # <% attorney = session[:user_id] %>
    #
    # set var = already_bought to all purchases by attorney
    # <% already_bought = User.find(attorney).properties %>
    #
    # set var = avail_to_buy to all Properties
    # <% avail_to_buy = Property.all %>
    #
    # deduct Attorney Purchases from Properties
    # <% avail_to_buy = avail_to_buy - already_bought %>

    # passing params to retrieve custom search Properties
      if params[:keyword1].blank? && params[:keyword2].blank?
        # if both bounds are blank, then just return leads not yet purchased
        @properties = Property.all - current_user.properties
      else
        # pass the params as a range as ---> keywords[:keyword1], keywords[:keyword2]
        # using keywords because ---> params[:keyword1] etc.; is not available outside this Class in the Property Model
        #                                   .where("today >= from_date AND today <= to_date")
        # Property.search(params) = Property.where("home_value >= 100000 AND home_value <= 500000")
        # Property.search is defined as a Method in the Property model
        @properties = Property.search(params) - current_user.properties
      end
    # end of new code
  end

  def create
    @properties = Property.all
  end

  # create purchase based on current_user and selected properties params['property.ids'] array
  def purchase
    params["property.ids"].each do |x|
      # create joins
      Purchase.create(user_id: current_user.id, property_id: x)
    end
    # send user back to dashboard index
    redirect_to action: 'index'
  end

end
