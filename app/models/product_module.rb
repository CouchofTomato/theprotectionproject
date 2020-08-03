class ProductModule < ApplicationRecord
  enum category: { 'core' => 0, 'outpatient' => 1, 'medicines and appliances' => 2, 'wellness' => 3,
                   'maternity' => 4, 'dental and optical' => 5, 'evacuation and repatriation' => 6 }
  VALID_CURRENCY = /
                    \A(eur|gbp|usd)\s?\d+,?\d*,?\d*\s?\|?\s?
                    (eur|gbp|usd)\s?\d+,?\d*,?\d*\s?\|?\s?
                    (eur|gbp|usd)\s?\d+,?\d*,?\d*\z
                   /ix.freeze

  belongs_to :product
  has_many :product_module_benefits, dependent: :destroy, inverse_of: :product_module

  validates :name, presence: true, uniqueness: { scope: :category, case_sensitive: false }
  validates :category, presence: true
  validates :sum_assured,
            presence: true,
            format: { with: VALID_CURRENCY,
                      message: 'Please write the sum assured in the format "USD X,XXX,XXX | GBP X,XXX,XXX | EUR X,XXX,XXX"' }

  accepts_nested_attributes_for :product_module_benefits
end
