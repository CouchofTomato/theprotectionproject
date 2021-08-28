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
    SuitableHealthProducts.match(
      AllProductModuleOptionsComparisonProducts.call, applicants, params[:coverages]
    )
  end

  def applicants
    @applicants ||= params['people'].map do |applicant_details|
      create_applicant(applicant_details)
    end
  end

  def create_applicant(applicant_details)
    ServiceModels::Applicant.new(
      name: applicant_details['name'],
      date_of_birth: Date.new(applicant_details['date_of_birth']['(1i)'].to_i,
                              applicant_details['date_of_birth']['(2i)'].to_i,
                              applicant_details['date_of_birth']['(3i)'].to_i),
      relationship: applicant_details['relationship'],
      nationality: applicant_details['nationality'],
      country_of_residence: applicant_details['country_of_residence']
    )
  end
end
