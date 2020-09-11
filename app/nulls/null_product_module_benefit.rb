# frozen_string_literal: true

class NullProductModuleBenefit
  def icon
    "<span class='icon'><i class='fa fa-times red-cross'></i></span>"
  end

  def benefit_limit
    'Not covered'
  end

  def explanation_of_benefit
    'Not Covered'
  end

  def benefit_status
    'not covered'
  end
end
