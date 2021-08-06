class ComparisonProduct
  include ActiveModel::Model

  attr_accessor :insurer, :product, :product_modules

  delegate :name, prefix: 'insurer', to: :insurer
  delegate :name, prefix: 'product', to: :product
  delegate :minimum_applicant_age, to: :product
  delegate :maximum_applicant_age, to: :product

  def product_module_names
    product_modules.map(&:name).join(' + ')
  end

  def overall_sum_assured
    product_modules.find { |product_module| product_module.category == 'core' }
                   .sum_assured
  end

  def module_benefits
    @module_benefits ||= selected_benefits.keep_if { benefit_with_maximum_weight(_1) == _1 }
  end

  def module_benefit(benefit_id)
    product_module_benefit = module_benefits.find { _1.benefit_id == benefit_id }
    product_module_benefit || NullProductModuleBenefit.new
  end

  def coverage_areas?(coverages)
    (coverages - coverage_area_categories).empty?
  end

  private

  def selected_benefits
    product_modules.map(&:product_module_benefits).flatten
  end

  def benefit_with_maximum_weight(module_benefit)
    matched_benefits(module_benefit).max_by(&:benefit_weighting)
  end

  def matched_benefits(module_benefit)
    selected_benefits.find_all { _1.benefit.name == module_benefit.benefit.name }
  end

  def coverage_area_categories
    product_modules.flat_map { |product_module| product_module.coverage_areas.map(&:category) }
  end
end
