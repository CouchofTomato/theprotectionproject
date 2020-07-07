# frozen_string_literal: true

module ApplicationHelper
  def bulma_class_for(type)
    { 'notice' => 'is-success', 'alert' => 'is-danger' }.fetch(type)
  end
end
