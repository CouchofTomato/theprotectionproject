# frozen_string_literal: true

class NullProductModuleBenefit
  def benefit_limit
    'Not covered'
  end

  def explanation_of_benefit
    'Not Covered'
  end

  def benefit_status
    'not_covered'
  end

  alias full_benefit_coverage explanation_of_benefit
end
