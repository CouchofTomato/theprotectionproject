class Insurer < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
