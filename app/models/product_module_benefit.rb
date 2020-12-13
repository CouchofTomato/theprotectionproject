class ProductModuleBenefit < ApplicationRecord
  belongs_to :product_module, inverse_of: :product_module_benefits
  belongs_to :benefit

  enum benefit_status: { paid_in_full: 0, capped_benefit: 1 }

  validates :benefit_status, presence: true
  validates :benefit_limit, presence: true
  validates :product_module_id, uniqueness: { scope: :benefit_id }

  def full_benefit_coverage
    <<~BENEFIT.strip
      #{benefit_limit}

      #{explanation_of_benefit}
    BENEFIT
  end
end
