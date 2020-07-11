# frozen_string_literal: true

User.create(email: 'admin@email.com', password: 'admin123', admin: true)
User.create(email: 'user@email.com', password: 'user123')
