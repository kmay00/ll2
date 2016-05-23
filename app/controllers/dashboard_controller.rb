class DashboardController < ApplicationController
  def index
    @properties = Property.all
  end
end
