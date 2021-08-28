class SuitableHealthProductPolicy
  def initialize(required_coverages, applicants)
    @required_coverages = required_coverages
    @applicants = applicants
  end

  def allowed?(health_product)
    @health_product = health_product

    required_coverages? &&
      core_module_outpatient_cover_check_valid? &&
      main_applicant_age_valid? &&
      dependants_ages_valid?
  end

  private

  attr_reader :health_product, :required_coverages, :applicants

  def required_coverages?
    health_product.coverage_areas?(required_coverages)
  end

  def core_module_outpatient_cover_check_valid?
    return true if required_coverages.include? 'outpatient'

    core_module.coverage_areas.none?(&:outpatient?)
  end

  def main_applicant_age_valid?
    main_applicant.age.between?(health_product.minimum_applicant_age, health_product.maximum_applicant_age)
  end

  def dependants_ages_valid?
    dependant_applicants
      .map(&:age)
      .all? { _1 < health_product.maximum_applicant_age }
  end

  def core_module
    health_product.product_modules.find(&:core?)
  end

  def main_applicant
    applicants.find { _1.relationship == 'self' }
  end

  def dependant_applicants
    applicants
      .reject { _1.relationship == 'self' }
  end
end
