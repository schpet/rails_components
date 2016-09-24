module RailsComponents
  module MergeHtml
    def merge_html(new_html_attributes)
      merge(new_html_attributes) do |key, v1, v2| 
        [v1, v2].flatten(1)
      end
    end
  end
end
