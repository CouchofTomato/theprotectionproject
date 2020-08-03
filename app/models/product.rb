class Product < ApplicationRecord
  belongs_to :insurer
  has_many :product_modules, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :insurer, presence: true
end
