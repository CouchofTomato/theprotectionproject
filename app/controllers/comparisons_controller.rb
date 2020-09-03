class ComparisonsController < ApplicationController
  def new
    @benefits = Benefit.grouped_by_category
    @benefit_categories = @benefits.keys
  end
end
