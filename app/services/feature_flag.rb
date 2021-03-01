class FeatureFlag
  def self.enabled?(feature_name)
    case feature_name.to_sym
    when :suitable_plan_form
      !Rails.env.production?
    else
      true
    end
  end
end
