class ComparisonProduct
  attr_reader :insurer, :product, :product_modules, :all_selected_benefits

  delegate :name, prefix: 'insurer', to: :insurer
  delegate :name, prefix: 'product', to: :product

  def initialize(insurer, product, product_modules)
    @insurer = insurer
    @product = product
    @product_modules = product_modules
    @all_selected_benefits = selected_benefits
  end

  def product_module_names
    product_modules.map(&:name).join(' + ')
  end

  def overall_sum_assured
    product_modules.find { |product_module| product_module.category == 'core' }
                   .sum_assured
  end

  def module_benefits
    @module_benefits ||= all_selected_benefits.keep_if { benefit_with_maximum_weight(_1) == _1 }
  end

  def module_benefit(benefit_id)
    module_benefits.find { _1.benefit_id == benefit_id }
  end

  private

  def selected_benefits
    product_modules.map(&:product_module_benefits).flatten
  end

  def benefit_with_maximum_weight(module_benefit)
    matched_benefits(module_benefit).max_by(&:benefit_weighting)
  end

  def matched_benefits(module_benefit)
    all_selected_benefits.find_all { _1.benefit.name == module_benefit.benefit.name }
  end
end
