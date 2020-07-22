class ProductModule < ApplicationRecord
  CATEGORIES =
    %w[
      core
      outpatient
      medicines_and_appliances
      wellness
      maternity
      dental_and_optical
      evacuation_and_repatriation
    ].freeze
  VALID_CURRENCY = /
                    \A(eur|gbp|usd)\s?\d+,?\d*,?\d*\s?\|?\s?
                    (eur|gbp|usd)\s?\d+,?\d*,?\d*\s?\|?\s?
                    (eur|gbp|usd)\s?\d+,?\d*,?\d*\z
                   /ix.freeze

  belongs_to :product
  validates :name, presence: true, uniqueness: { scope: :category, case_sensitive: false }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :sum_assured,
            presence: true,
            format: { with: VALID_CURRENCY,
                      message: 'Please write the sum assured in the format "USD X,XXX,XXX | GBP X,XXX,XXX | EUR X,XXX,XXX"' }
end
