# frozen_string_literal: true

module ApplicationHelper
  def bulma_class_for(type)
    bulma_classes.fetch(type)
  end

  private

  def bulma_classes
    { 'notice' => 'is-success', 'alert' => 'is-danger' }
  end
end
