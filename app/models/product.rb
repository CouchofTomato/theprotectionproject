class Product < ApplicationRecord
  enum customer_type: { 'individual' => 0, 'corporate' => 1 }

  belongs_to :insurer
  has_many :product_modules, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :minimum_applicant_age, presence: true
  validates :maximum_applicant_age, presence: true
  validates :insurer, presence: true

  scope :individual_products, -> { where(customer_type: 'individual') }

  def core_modules
    product_modules.where(product_modules: { category: 'core' })
  end
end
