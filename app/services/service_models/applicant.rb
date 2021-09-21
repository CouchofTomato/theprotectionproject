# frozen_string_literal: true

module ServiceModels
  class Applicant
    include ActiveModel::Model

    attr_accessor :name, :date_of_birth, :relationship, :nationality, :country_of_residence

    validates :name, presence: true
    validates :date_of_birth, presence: true
    validates :relationship, presence: true
    validates :nationality, presence: true
    validates :country_of_residence, presence: true

    def age
      ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
    end
  end
end
