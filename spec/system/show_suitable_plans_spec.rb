require 'rails_helper'

RSpec.describe 'Site visitor completes questionnaire and is shown suitable plans', type: :system, js: true do
  it 'takes questionnaire answers and shows the plans that most closely match' do
    visit root_path
    click_on 'Recommend A Plan To Me'

    page.choose('Inpatient')
    page.choose('Outpatient')
    page.choose('Evacuation')

    
  end
end
