class AllProductModuleOptionsComparisonProducts
  def self.call
    new.call
  end

  attr_accessor :comparison_products

  def initialize
    @comparison_products = []
  end

  def call
    generate_comparison_products
    comparison_products
  end

  def generate_comparison_products
    insurers.each do |insurer|
      insurer.products.each do |product|
        product.product_modules.each do |product_module|
          [product_module].product(*product_module.linked_modules.group_by(&:category).values).each do |product_module_option|
            add_comparison_product(insurer, product, product_module_option)
          end
        end
      end
    end
  end

  def add_comparison_product(insurer, product, product_modules)
    comparison_products.push(
      ComparisonProduct.new(
        insurer: insurer,
        product: product,
        product_modules: product_modules
      )
    )
  end

  def insurers
    Insurer.includes(products: { product_modules: [:coverage_areas, { linked_modules: :coverage_areas }] })
           .where(products: { customer_type: 'individual', product_modules: { category: 'core' } })
  end
end
