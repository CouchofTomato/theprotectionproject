class CoverageArea < ApplicationRecord
  enum category: { inpatient: 0, outpatient: 1, medicines_and_appliances: 3, maternity: 4,
                   evacuation: 5, wellness: 6, dental: 7, optical: 8, repatriation: 9 }

  belongs_to :product_module

  validates :category, presence: true, uniqueness: { scope: :product_module_id }
end
