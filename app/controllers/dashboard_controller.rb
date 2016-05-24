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
end
