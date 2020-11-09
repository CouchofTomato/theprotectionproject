class OrderedBenefitsQuery
  attr_reader :benefits, :order

  class << self
    def all(benefits = Benefit.all, order = :by_name)
      new(benefits, order).all
    end
  end

  def initialize(benefits, order)
    @benefits = benefits
    @order = order
  end

  def all
    benefits.send(order)
  end
end
