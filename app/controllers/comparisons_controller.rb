class ComparisonsController < ApplicationController
  def new
    @benefits = Benefit.grouped_by_category
    @benefit_categories = Benefit.categories.keys.select { @benefits.keys.include?(_1) }
  end
end
