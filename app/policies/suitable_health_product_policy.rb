class SuitableHealthProductPolicy
  def initialize(health_product, required_coverages:, main_applicant_age:, dependants_ages:)
    @health_product = health_product
    @required_coverages = required_coverages
    @main_applicant_age = main_applicant_age
    @dependants_ages = dependants_ages
  end

  def allowed?
    required_coverages? &&
      core_module_outpatient_cover_check_valid? &&
      main_applicant_age_valid? &&
      dependants_ages_valid?
  end

  private

  attr_reader :health_product, :required_coverages, :main_applicant_age, :dependants_ages

  def required_coverages?
    health_product.coverage_areas?(required_coverages)
  end

  def core_module_outpatient_cover_check_valid?
    return true if required_coverages.include? 'outpatient'

    core_module.coverage_areas.none?(&:outpatient?)
  end

  def main_applicant_age_valid?
    main_applicant_age.between?(health_product.minimum_applicant_age, health_product.maximum_applicant_age)
  end

  def dependants_ages_valid?
    dependants_ages.all? { _1 < health_product.maximum_applicant_age}
  end

  def core_module
    health_product.product_modules.find(&:core?)
  end
end
