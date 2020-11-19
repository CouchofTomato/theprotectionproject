class ComparisonsController < ApplicationController
  before_action :set_grouped_benefits, only: %i[new show]
  before_action :set_benefit_categories, only: %i[new show]

  def new
    @insurers = Insurer
                .offers_products_with_customer_type(params[:customer_type])
                .order(:name)
  end

  def show
    @comparison_products = comparison_products(params[:selected_products])

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="comparison.xlsx"'
      end
    end
  end

  private

  def set_grouped_benefits
    @grouped_benefits = OrderedBenefitsQuery.all(covered_benefits).group_by(&:category)
  end

  def set_benefit_categories
    @benefit_categories = Benefit.categories.keys.select { @grouped_benefits.key? _1 }
  end

  def comparison_products(selected_products)
    selected_products.map do |selected_product|
      ComparisonProduct.new(Insurer.find(selected_product[:insurer]),
                            Product.find(selected_product[:product]),
                            product_modules(selected_product[:product_modules]))
    end
  end

  def product_modules(product_modules)
    ProductModule.includes(:product_module_benefits).find(selected_modules(product_modules))
  end

  def selected_modules(modules)
    modules.values.flatten
  end

  def covered_benefits
    CoveredBenefits.all(@comparison_products, params[:options])
  end
end
