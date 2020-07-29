class ProductModuleBenefit < ApplicationRecord
  belongs_to :product_module
  belongs_to :benefit

  enum benefit_status: { 'paid in full' => 0, 'capped benefit' => 1 }

  validates :benefit_status, presence: true
  validates :benefit_limit, presence: true
  validates :product_module_id, uniqueness: { scope: :benefit_id }
end
