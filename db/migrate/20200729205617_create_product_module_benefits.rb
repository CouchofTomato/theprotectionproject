class CreateProductModuleBenefits < ActiveRecord::Migration[6.0]
  def change
    create_table :product_module_benefits do |t|
      t.references :product_module, null: false, foreign_key: true
      t.references :benefit, null: false, foreign_key: true
      t.integer :benefit_status, null: false
      t.string :benefit_limit, null: false
      t.text :explanation_of_benefit

      t.timestamps
    end
    add_index :product_module_benefits, %i[product_module_id benefit_id],
              unique: true, name: 'index_product_module_benefits_on_product_module_and_benefit'
  end
end
