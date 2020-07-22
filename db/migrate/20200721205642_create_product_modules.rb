class CreateProductModules < ActiveRecord::Migration[6.0]
  def change
    create_table :product_modules do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :sum_assured, null: false
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
    add_index :product_modules, %i[name category], unique: true
  end
end
