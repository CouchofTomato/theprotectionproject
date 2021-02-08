class CreateLinkedProductModules < ActiveRecord::Migration[6.1]
  def change
    create_table :linked_product_modules do |t|
      t.references :product_module, null: false, foreign_key: true
      t.references :linked_module, null: false

      t.timestamps
    end

    add_foreign_key :linked_product_modules, :product_modules, column: :linked_module_id
  end
end
