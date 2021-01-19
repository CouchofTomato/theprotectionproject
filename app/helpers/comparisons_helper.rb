module ComparisonsHelper
  def active_product_module_categories(categories, product_modules)
    categories.select do |category|
      product_modules.any? { |product_module| product_module.category == category }
    end
  end
end
