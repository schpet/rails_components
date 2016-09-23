# Rails Components

It allows you to write reusable components in your rails views.

## Installation

Install the rails components gem by adding it to your Gemfile:

```rb
gem 'rails_components'
```

Include RailsComponents in your app/helpers/application_helper.rb:

```rb
module ApplicationHelper
  include RailsComponents
end
```

Override the `local_prefixes` method in your controllers, which lets you 
write `component 'modal'` instead of `component 'components/modal'`:

```
class ApplicationController < ActionController::Base

  private

  def self.local_prefixes
    super + ['components']
  end
end
```

## Examples:

Bootstrap modal, with an ID, in erb:

```erb
<% content_tag :div, class: ['modal', props[:class]] do %>
  <div class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <%= yield %>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
<% end %>
```

```erb
<div class="modal-header">
  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  <h4 class="modal-title"><%= yield %></h4>
</div>
```

```erb
<div class="modal-body">
  <%= yield %>
</div>
```

```erb
<div class="modal-footer">
  <%= yield %>
</div>
```

```erb
<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
```


# Goals

- make it as easy to write reusable components
- feel familiar to existing rails helpers, like `link_to` or `content_tag` 
