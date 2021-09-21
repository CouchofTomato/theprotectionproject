module SuitablePlansHelper
  def coverage_type_icon(coverage_type)
    coverage_type_icons.fetch(coverage_type)
  end

  private

  # rubocop:disable Metrics/MethodLength
  def coverage_type_icons
    {
      'inpatient' => 'fa-hospital-user',
      'outpatient' => 'fa-stethoscope',
      'medicines_and_appliances' => 'fa-prescription-bottle',
      'maternity' => 'fa-baby-carriage',
      'evacuation' => 'fa-plane-departure',
      'repatriation' => 'fa-home',
      'wellness' => 'fa-spa',
      'dental' => 'fa-tooth',
      'optical' => 'fa-glasses'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
