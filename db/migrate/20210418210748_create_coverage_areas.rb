class CreateCoverageAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :coverage_areas do |t|
      t.integer :category, null: false
      t.references :product_module, null: false, foreign_key: true

      t.timestamps
    end
    add_index :coverage_areas, %i[category product_module_id],
              unique: true, name: 'index_coverage_areas_on_category_and_product_module'
  end
end
