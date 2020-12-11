class AddIndexToProductModules < ActiveRecord::Migration[6.0]
  def change
    remove_index :product_modules, %i[name category]
    add_index :product_modules, %i[name category product_id], unique: true
  end
end
