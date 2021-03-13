module SuitablePlansHelper
  def coverage_type_icon(coverage_type)
    coverage_type_icons.fetch(coverage_type)
  end

  private

  def coverage_type_icons
    {
      'inpatient' => 'fa-hospital-user',
      'outpatient' => 'fa-stethoscope',
      'wellness' => 'fa-spa'
    }
  end
end
