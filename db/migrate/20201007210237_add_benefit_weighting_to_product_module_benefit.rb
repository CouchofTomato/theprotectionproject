class AddBenefitWeightingToProductModuleBenefit < ActiveRecord::Migration[6.0]
  def change
    add_column :product_module_benefits, :benefit_weighting, :integer, default: 0
  end
end
