class LinkedProductModule < ApplicationRecord
  belongs_to :product_module
  belongs_to :linked_module, class_name: 'ProductModule', inverse_of: :linked_product_modules
end
