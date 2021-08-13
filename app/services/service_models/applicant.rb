# frozen_string_literal: true

module ServiceModels
  class Applicant
    attr_reader :name, :date_of_birth, :relationship, :nationality, :country_of_residence

    def initialize(name:, date_of_birth:, relationship:, nationality:, country_of_residence:)
      @name = name
      @date_of_birth = date_of_birth
      @relationship = relationship
      @nationality = nationality
      @country_of_residence = country_of_residence
    end

    def age
      ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
    end
  end
end
