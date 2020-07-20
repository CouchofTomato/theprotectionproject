class Benefit < ApplicationRecord
  CATEGORIES =
    %w[
      inpatient
      outpatient
      therapists
      medicines_and_appliances
      wellness
      evacuation_and_repatriation
      maternity
      dental
      optical
      additional
    ].freeze
  validates :name, presence: true, uniqueness: { scope: :category, case_sensitive: false }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end
