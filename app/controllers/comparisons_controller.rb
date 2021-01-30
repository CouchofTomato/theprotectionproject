class ComparisonsController < ApplicationController
  def new
    @grouped_benefits = OrderedBenefitsQuery.all(covered_benefits).group_by(&:category)
    @benefit_categories = Benefit.categories.keys.select { @grouped_benefits.key? _1 }
    @insurers = Insurer
                .offers_products_with_customer_type(params[:customer_type])
                .order(:name)
    @comparison_products ||= []
    @product_module_categories = ProductModule.categories.keys
  end

  def show
    @comparison_products = comparison_products(params[:comparison_products][:selection])
    @grouped_benefits = OrderedBenefitsQuery.all(covered_benefits).group_by(&:category)
    @benefit_categories = Benefit.categories.keys.select { @grouped_benefits.key? _1 }

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="comparison.xlsx"'
      end
    end
  end

  private

  def comparison_products(selected_products)
    selected_products.map do |selected_product|
      ComparisonProduct.new(Insurer.find(selected_product[:insurer]),
                            Product.find(selected_product[:product]),
                            product_modules(selected_product[:product_modules]))
    end
  end

  def product_modules(product_modules)
    ProductModule.includes(product_module_benefits: :benefit).find(product_modules)
  end

  def covered_benefits
    CoveredBenefits.all(@comparison_products, params[:options])
  end
end
