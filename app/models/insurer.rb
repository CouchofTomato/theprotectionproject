class Insurer < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :offers_products_with_customer_type, ->(type) { includes(:products).where(products: { customer_type: type }) }
end
