module ComparisonsHelper
  def active_product_module_categories(product_modules)
    ProductModule.categories.keys.select do |category|
      product_modules.any? { |product_module| product_module.category == category }
    end
  end

  def active_benefit_categories(benefits)
    benefit_categories = Benefit.categories.keys
    benefit_categories.select { |category| benefits.any? { |benefit| benefit.category == category } }
  end

  def coverage_icon(product_module_benefit)
    icons.fetch(product_module_benefit.benefit_status)
  end

  def benefits_grouped_by_category(benefits)
    benefits.group_by(&:category)
  end

  def selected_core_module?(module_id, core_module)
    return false unless core_module

    module_id == core_module.id
  end

  private

  def icons
    {
      'paid_in_full' => 'fa fa-check icon--full-cover',
      'capped_benefit' => 'fa fa-circle-notch icon--capped-cover',
      'not_covered' => 'fa fa-times icon--not-covered'
    }
  end
end
