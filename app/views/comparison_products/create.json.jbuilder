json.insurer do
  json.name @comparison_product.insurer.name
end
json.product do
  json.name @comparison_product.product.name
end
json.product_modules @comparison_product.product_modules do |product_module|
  json.(product_module, :name, :category, :sum_assured)
end
json.module_benefits @comparison_product.module_benefits do |product_module_benefit|
  json.(product_module_benefit, :benefit_status, :benefit_limit, :explanation_of_benefit)
  json.benefit do
    json.(product_module_benefit.benefit, :id, :name, :category)
  end
end
