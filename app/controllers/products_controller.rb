class ProductsController < ApplicationController
  def index
    @products = set_products

    respond_to do |format|
      format.json { render json: @products }
    end
  end

  private

  def set_products
    if params[:customer_type]
      Insurer.find(params[:insurer_id]).products.where(customer_type: params[:customer_type])
    else
      Insurer.find(params[:insurer_id]).products
    end
  end
end
