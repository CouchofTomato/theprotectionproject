# frozen_string_literal: true

unless Rails.env.development?
  Rails.logger.info "[ db/seeds.rb ] Seed data is for development only, not #{Rails.env}"
  exit 0
end
