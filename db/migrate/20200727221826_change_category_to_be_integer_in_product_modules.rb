class ChangeCategoryToBeIntegerInProductModules < ActiveRecord::Migration[6.0]
  def up
    change_column :product_modules, :category, :integer, using: 'category::integer'
  end

  def down
    change_column :product_module, :category, :string
  end
end
