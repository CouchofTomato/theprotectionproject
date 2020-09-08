json.insurer do
  json.name @insurer.name
end
json.product do
  json.name @product.name
end
json.product_modules @product_modules do |product_module|
  json.(product_module, :name, :category, :sum_assured)
  json.product_module_benefits product_module.product_module_benefits do |product_module_benefit|
    json.(product_module_benefit, :benefit_status, :benefit_limit, :explanation_of_benefit)
    json.benefit do
      json.(product_module_benefit.benefit, :id, :name, :category)
    end
  end
end
