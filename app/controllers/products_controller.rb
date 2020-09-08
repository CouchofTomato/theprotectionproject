class ProductsController < ApplicationController
  def index
    @products = Insurer.find(params[:insurer_id]).products

    respond_to do |format|
      format.json { render json: @products }
    end
  end
end
