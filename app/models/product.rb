class Product < ApplicationRecord
  belongs_to :insurer
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
