class SuitablePlansController < ApplicationController
  def new
    @coverage_types = %w[inpatient outpatient wellness]
    @deductibles = %w[0 100-500 500-2000 2000-5000 5000-10000 10000+]
  end
end
