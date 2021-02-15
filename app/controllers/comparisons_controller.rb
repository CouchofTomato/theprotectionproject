class ComparisonsController < ApplicationController
  before_action :set_insurers, only: [:new]

  def new
    @comparison_products = [] unless @stimulus_reflex
    @benefits = Benefit.order(name: :asc)
  end

  def show
    @comparison_products = comparison_products(params[:comparison_products][:selection])
    @benefits = filtered_benefits.order(name: :asc)

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="comparison.xlsx"'
      end
    end
  end

  private

  def set_insurers
    @insurers = Insurer
                .offers_products_with_customer_type(params[:customer_type])
                .order(:name)
  end

  def comparison_products(selected_products)
    selected_products.map do |selected_product|
      ComparisonProduct.new(insurer: Insurer.find(selected_product[:insurer]),
                            product: Product.find(selected_product[:product]),
                            product_modules: product_modules(selected_product[:product_modules]))
    end
  end

  def product_modules(product_modules)
    ProductModule.includes(product_module_benefits: :benefit).find(product_modules)
  end

  def filtered_benefits
    return Benefit.all unless params[:options]

    benefits = Benefit.all
    benefits.where(id: active_benefit_ids) if params[:options].include? 'covered_benefits'
  end

  def active_benefit_ids
    @comparison_products
      .map(&:module_benefits)
      .flatten
      .map(&:benefit_id)
      .uniq
  end
end
