require 'rails_helper'

RSpec.describe 'Site visitor completes questionnaire and is shown suitable plans', type: :system, js: true do
  xit 'takes questionnaire answers and shows the plans that most closely match' do
    visit root_path
    find(:test_id, 'plan-recommendation-btn').click

    within(find(:test_id, 'people-information-section')) do
      find(:test_id, 'people-name-input').fill_in with: 'Jon Doe'
      select '10', from: '_people__date_of_birth_3i'
      select 'May', from: '_people__date_of_birth_2i'
      select '1984', from: '_people__date_of_birth_1i'
      find(:test_id, 'people-nationality-input').fill_in with: 'British'
      find(:test_id, 'people-residency-input').fill_in with: 'United Kingdom'
      find(:test_id, 'people-relationship-select').select 'self'
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'coverage-areas-section')) do
      find(:test_id, 'inpatient-checkbox').check
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'usa-cover-section')) do
      find(:test_id, 'usa-cover-yes-radio-btn').choose
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'existing-conditions-section')) do
      find(:test_id, 'existing-conditions-no-radio-btn').choose
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'deductibles-section')) do
      find(:test_id, '0-checkbox').check
      find(:test_id, '100-500-checkbox').check
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'existing-cover-section')) do
      find(:test_id, 'existing-cover-no-radio-btn').choose
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'preferences-section')) do
      find(:test_id, 'brand-recognition-preference-input').fill_in with: 4
      find(:test_id, 'financial-strength-preference-input').fill_in with: 4
      find(:test_id, 'cost-of-cover-preference-input').fill_in with: 4
      find(:test_id, 'online-facilities-preference-input').fill_in with: 4
      find(:test_id, 'communication-preference-input').fill_in with: 4
      find(:test_id, 'direct-settlement-preference-input').fill_in with: 4
    end

    find(:test_id, 'next-tab-btn').click

    within(find(:test_id, 'submit-section')) do
      find(:test_id, 'suitable-plan-form-submit-btn').click
    end

    within(find(:test_id, 'most-suitable-plan')) do
      expect(page).to have_text 'BUPA Global'
      expect(page).to have_text 'Lifeline'
      expect(page).to have_text 'Essential'
    end
  end
end
