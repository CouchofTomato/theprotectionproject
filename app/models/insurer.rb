class Insurer < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :products, dependent: :destroy
end
