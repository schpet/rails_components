# meant to be mixed into a hash
module RailsComponents
  module HtmlHelpers
    def html(html_attributes_to_merge = {})
      strategy = delete(:html_merge_strategy) || :combine

      case strategy.to_sym
      when :combine
        merge(html_attributes_to_merge) { |key, v1, v2| [v1, v2].flatten(1) }
      when :merge
        html_attributes_to_merge.merge(self)
      when :replace
        self
      else
        raise "unknown html_merge_stragey: #{strategy}"
      end
    end
  end
end
