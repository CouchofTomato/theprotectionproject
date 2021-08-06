class AddMinimumAndMaximumAgeToProducts < ActiveRecord::Migration[6.1]
  def change
    change_table :products, bulk: true do |t|
      t.integer :minimum_applicant_age
      t.integer :maximum_applicant_age
    end

    Product.find_each do |product|
      product.update(minimum_applicant_age: 18, maximum_applicant_age: 80)
    end

    change_column_null :products, :minimum_applicant_age, false
    change_column_null :products, :maximum_applicant_age, false
  end
end
