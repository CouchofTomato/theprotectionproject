class ProductModule < ApplicationRecord
  enum category: { 'core' => 0, 'outpatient' => 1, 'medicines and appliances' => 2, 'wellness' => 3,
                   'maternity' => 4, 'dental and optical' => 5, 'evacuation and repatriation' => 6 }

  belongs_to :product
  has_many :product_module_benefits, dependent: :destroy, inverse_of: :product_module

  validates :name, presence: true, uniqueness: { scope: %i[category product_id], case_sensitive: false }
  validates :category, presence: true
  validates :sum_assured, presence: true

  accepts_nested_attributes_for :product_module_benefits
end
