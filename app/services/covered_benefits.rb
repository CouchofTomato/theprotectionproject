class CoveredBenefits
  attr_accessor :comparison_products, :options, :benefits

  class << self
    def all(comparison_products, options = [])
      new(comparison_products, options).all
    end
  end

  def initialize(comparison_products, options, benefits = Benefit.all)
    @comparison_products = comparison_products
    @options = options
    @benefits = benefits
  end

  def all
    return benefits if options.empty?

    options.inject(self, :send)
  end

  def covered_benefits
    benefits.where(id: active_benefit_ids)
  end

  def active_benefit_ids
    comparison_products
      .map(&:module_benefits)
      .flatten
      .map(&:benefit_id)
      .uniq
  end
end
