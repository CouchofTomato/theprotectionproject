class ComparisonsController < ApplicationController
  def new
    @benefits = Benefit.all
  end
end
