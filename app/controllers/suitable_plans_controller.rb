class SuitablePlansController < ApplicationController
  def new
    @deductibles = %w[0 100-500 500-2000 2000-5000 5000-10000 10000+]
    @suitable_plans_form = SuitablePlansForm.new
  end

  def show
    @deductibles = %w[0 100-500 500-2000 2000-5000 5000-10000 10000+]
    @suitable_plans_form = SuitablePlansForm.new(suitable_plans_form_params)
    if @suitable_plans_form.submit
      @suitable_plans = suitable_plans
    else
      render :new
    end
  end

  private

  def suitable_plans_form_params
    params.require(:suitable_plans_form).permit(
      coverages: [],
      applicants_attributes: %i[name date_of_birth relationship nationality country_of_residence]
    )
  end

  def suitable_plans
    SuitableHealthProducts.match(
      AllProductModuleOptionsComparisonProducts.call, @suitable_plans_form.applicants, @suitable_plans_form.coverages
    )
  end
end
