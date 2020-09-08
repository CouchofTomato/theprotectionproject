class ProductModulesController < ApplicationController
  def index
    @product_modules = Product.find(params[:product_id]).product_modules

    respond_to do |format|
      format.json { render json: @product_modules }
    end
  end
end
