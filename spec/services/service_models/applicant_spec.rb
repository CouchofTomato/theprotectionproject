require 'rails_helper'

RSpec.describe ServiceModels::Applicant, type: :model do
  subject(:applicant) do
    described_class.new(name: name,
                        date_of_birth: date_of_birth,
                        relationship: relationship,
                        nationality: nationality,
                        country_of_residence: country_of_residence)
  end

  let(:name) { 'Joe' }
  let(:relationship) { 'self' }
  let(:date_of_birth) { DateTime.new(1970, 1, 1) }
  let(:nationality) { 'British' }
  let(:country_of_residence) { 'United Kingdom' }

  it { expect(applicant).to validate_presence_of :name }
  it { expect(applicant).to validate_presence_of :date_of_birth }
  it { expect(applicant).to validate_presence_of :relationship }
  it { expect(applicant).to validate_presence_of :nationality }
  it { expect(applicant).to validate_presence_of :country_of_residence }

  describe '#age' do
    context 'when the applicants birthday was earlier in the current year from the current date' do
      let(:date_of_birth) { DateTime.new(1970, 1, 1) }

      before do
        allow(Time).to receive(:now).and_return(Time.zone.parse('2021-02-01'))
      end

      it 'calcuates their current age including the one in the current year' do
        expect(applicant.age).to eq 51
      end
    end

    context 'when the applicants birthday is later in the year from the current date' do
      let(:date_of_birth) { DateTime.new(1970, 2, 1) }

      before do
        allow(Time).to receive(:now).and_return(Time.zone.parse('2021-01-01'))
      end

      it 'calculates their age not including the one in the current year' do
        expect(applicant.age).to eq 50
      end
    end

    context 'when the applicants birthday is the current date' do
      let(:date_of_birth) { DateTime.new(1970, 1, 1) }

      before do
        allow(Time).to receive(:now).and_return(Time.zone.parse('2021-01-01'))
      end

      it 'calcuates their current age including the one in the current year' do
        expect(applicant.age).to eq 51
      end
    end
  end
end
