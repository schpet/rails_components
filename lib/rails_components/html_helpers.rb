# meant to be mixed into a hash
module RailsComponents
  module HtmlHelpers
    def html(html_attributes_to_merge = {})
      merge(html_attributes_to_merge) { |key, v1, v2| [v1, v2].flatten(1) }
    end
  end
end
