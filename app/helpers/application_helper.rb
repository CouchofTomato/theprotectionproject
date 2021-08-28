# frozen_string_literal: true

module ApplicationHelper
  def bulma_class_for(type)
    bulma_classes.fetch(type)
  end

  # rubocop:disable Rails/OutputSafety
  def svg_icon(filename)
    file_path = Rails.root.join('app', 'assets', 'images', 'icons', "#{filename}.svg")
    return unless File.exist?(file_path)

    File.read(file_path).html_safe
  end
  # rubocop:enable Rails/OutputSafety

  private

  def bulma_classes
    { 'notice' => 'is-success', 'alert' => 'is-danger' }
  end
end
