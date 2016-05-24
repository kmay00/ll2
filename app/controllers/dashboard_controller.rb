class DashboardController < ApplicationController

  def index
    @properties = Property.all
  end

  def create
    @properties = Property.all
  end

  def show
    @properties = Property.all
    @purchases = Purchase.all
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
