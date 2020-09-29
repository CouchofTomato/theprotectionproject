class AddCustomerTypeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :customer_type, :integer
  end
end
