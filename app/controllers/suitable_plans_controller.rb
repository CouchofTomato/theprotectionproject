class SuitablePlansController < ApplicationController
  def new
    @coverage_types = %w[inpatient outpatient medicines_and_appliances maternity
                         evacuation_and_repatriation wellness dental optical]
    @deductibles = %w[0 100-500 500-2000 2000-5000 5000-10000 10000+]
  end

  def show
    @suitable_plans = suitable_plans
  end

  private

  def suitable_plans
    MatchedCoverageComparisonProducts.match(
      params[:coverages],
      AllProductModuleOptionsComparisonProducts.call
    )
  end
end
