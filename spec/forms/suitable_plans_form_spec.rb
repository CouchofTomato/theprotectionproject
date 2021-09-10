require 'rails_helper'

RSpec.describe SuitablePlansForm do
  subject(:suitable_plans_form) { described_class.new }

  describe '#new' do
    context 'when no applicant information is passed in' do
      it 'adds one applicant' do
        expect(suitable_plans_form.applicants.length).to eq 1
      end

      # rubocop:disable RSpec/ExampleLength
      it 'is a blank applicant' do
        expect(suitable_plans_form.applicants).to include(
          an_object_having_attributes(
            name: nil,
            date_of_birth: nil,
            relationship: nil,
            nationality: nil,
            country_of_residence: nil
          )
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'when applicant information is passed in' do
      subject(:suitable_plans_form) { described_class.new(suitable_plans_form_attributes) }

      let(:suitable_plans_form_attributes) do
        {
          'applicants_attributes' => {
            '0' => {
              'name' => 'Joe Bloggs',
              'date_of_birth(3i)' => '1',
              'date_of_birth(2i)' => '1',
              'date_of_birth(1i)' => '2000',
              'relationship' => 'self',
              'nationality' => 'British',
              'country_of_residence' => 'United Kingdom'
            },
            '1' =>
          { 'name' => 'Jane Bloggs',
            'date_of_birth(3i)' => '12',
            'date_of_birth(2i)' => '5',
            'date_of_birth(1i)' => '1998',
            'relationship' => 'self',
            'nationality' => 'British',
            'country_of_residence' => 'United Kingdom' }
          }
        }
      end

      # rubocop:disable RSpec/ExampleLength
      it 'assigns them to applicants' do
        expect(suitable_plans_form.applicants).to include(
          an_object_having_attributes(
            name: 'Joe Bloggs',
            date_of_birth: Date.new(2000, 1, 1)
          ),
          an_object_having_attributes(
            name: 'Jane Bloggs',
            date_of_birth: Date.new(1998, 5, 12)
          )
        )
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  describe '#add_applicant' do
    subject(:suitable_plans_form) { described_class.new(suitable_plans_form_attributes) }

    let(:suitable_plans_form_attributes) do
      {
        'applicants_attributes' => {
          '0' => {
            'name' => 'Joe Bloggs',
            'date_of_birth(3i)' => '1',
            'date_of_birth(2i)' => '1',
            'date_of_birth(1i)' => '2000',
            'relationship' => 'self',
            'nationality' => 'British',
            'country_of_residence' => 'United Kingdom'
          }
        }
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'adds a new blank applicant to the applicants' do
      suitable_plans_form.add_applicant
      expect(suitable_plans_form.applicants.last).to have_attributes(
        name: nil,
        date_of_birth: nil,
        relationship: nil,
        nationality: nil,
        country_of_residence: nil
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'all_coverages' do
    it 'returns an array of all the coverage categories available' do
      expect(suitable_plans_form.all_coverages).to eq(
        %w[inpatient outpatient medicines_and_appliances maternity
           evacuation repatriation wellness dental optical]
      )
    end
  end
end
