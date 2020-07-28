class Benefit < ApplicationRecord
  enum category: { inpatient: 0, outpatient: 1, therapists: 2,
                   medicines_and_appliances: 3, wellness: 4,
                   evacuation_and_repatriation: 5, maternity: 6,
                   dental: 7, optical: 8, additional: 9 }

  validates :name, presence: true, uniqueness: { scope: :category, case_sensitive: false }
  validates :category, presence: true
end
