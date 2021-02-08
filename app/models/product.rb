class Product < ApplicationRecord
  enum customer_type: { 'individual' => 0, 'corporate' => 1 }

  belongs_to :insurer
  has_many :product_modules, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :insurer, presence: true

  def core_modules
    product_modules.where(product_modules: { category: 'core' })
  end
end
