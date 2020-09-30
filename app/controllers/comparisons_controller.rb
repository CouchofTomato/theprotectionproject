class ComparisonsController < ApplicationController
  def new
    @grouped_benefits = Benefit.grouped_by_category
    @benefit_categories = Benefit.categories.keys.select { @grouped_benefits.key? _1 }
    @insurers = Insurer
                .offers_products_with_customer_type(params[:customer_type])
                .order(:name)
  end

  def show
    @comparison_products = comparison_products(params[:selected_products])
    @grouped_benefits = Benefit.grouped_by_category
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
      ComparisonProduct.new(
        Insurer.find(selected_product[:insurer]),
        Product.find(selected_product[:product]),
        ProductModule.includes(:product_module_benefits).find(selected_modules(selected_product[:product_modules]))
      )
    end
  end

  def selected_modules(modules)
    modules.values.flatten
  end
end
