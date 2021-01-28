module ComparisonsHelper
  def active_product_module_categories(categories, product_modules)
    categories.select do |category|
      product_modules.any? { |product_module| product_module.category == category }
    end
  end

  def coverage_icon(product_module_benefit)
    icons.fetch(product_module_benefit.benefit_status)
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
