class SuitableHealthProductPolicy
  def initialize(health_product, required_coverages)
    @health_product = health_product
    @required_coverages = required_coverages
  end

  def allowed?
    required_coverages? &&
      core_module_outpatient_cover_check_valid?
  end

  private

  attr_reader :health_product, :required_coverages

  def required_coverages?
    health_product.coverage_areas?(required_coverages)
  end

  def core_module_outpatient_cover_check_valid?
    return true if required_coverages.include? 'outpatient'

    core_module.coverage_areas.none?(&:outpatient?)
  end

  def core_module
    health_product.product_modules.find(&:core?)
  end
end
