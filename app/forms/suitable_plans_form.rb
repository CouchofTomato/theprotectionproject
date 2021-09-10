# frozen_string_literal: true

class SuitablePlansForm
  include ActiveModel::Model

  attr_accessor :applicants, :coverages

  validate :applicants_are_valid

  def initialize(params = {})
    super(params)
    @applicants ||= [ServiceModels::Applicant.new]
  end

  def applicants_attributes=(values)
    @applicants = values.map do |_, applicant_details|
      create_applicant(applicant_details)
    end
  end

  def submit
    return false if invalid?

    true
  end

  def add_applicant
    applicants.push(ServiceModels::Applicant.new)
  end

  def all_coverages
    %w[inpatient outpatient medicines_and_appliances maternity
       evacuation repatriation wellness dental optical]
  end

  private

  def create_applicant(applicant_details)
    ServiceModels::Applicant.new(
      name: applicant_details['name'],
      date_of_birth: Date.new(applicant_details['date_of_birth(1i)'].to_i,
                              applicant_details['date_of_birth(2i)'].to_i,
                              applicant_details['date_of_birth(3i)'].to_i),
      relationship: applicant_details['relationship'],
      nationality: applicant_details['nationality'],
      country_of_residence: applicant_details['country_of_residence']
    )
  end

  def applicants_are_valid
    errors.add(:applicants, 'are invalid') if applicants.any?(&:invalid?)
  end
end
