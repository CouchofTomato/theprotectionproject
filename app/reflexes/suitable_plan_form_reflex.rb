# frozen_string_literal: true

class SuitablePlanFormReflex < ApplicationReflex
  delegate :view_context, to: :controller

  def add_person
    form = ActionView::Helpers::FormBuilder.new(
      nil, nil, view_context, {}
    )

    html = render(partial: 'suitable_plans/person', locals: { f: form,
                                                              icon_name: 'icon-people',
                                                              relationship_options: %w[spouse child sponsored_dependent] })

    cable_ready.append(selector: '#people', html: html)
    morph :nothing
  end
end
