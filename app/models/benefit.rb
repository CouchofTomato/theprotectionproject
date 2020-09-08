class Benefit < ApplicationRecord
  enum category: { 'inpatient' => 0, 'outpatient' => 1, 'therapists' => 2,
                   'medicines and appliances' => 3, 'wellness' => 4,
                   'evacuation and repatriation' => 5, 'maternity' => 6,
                   'dental' => 7, 'optical' => 8, 'additional' => 9 }

  validates :name, presence: true, uniqueness: { scope: :category, case_sensitive: false }
  validates :category, presence: true

  scope :ordered_by_name, -> { order(name: :asc) }

  def self.grouped_by_category
    ordered_by_name.group_by(&:category)
  end
end
