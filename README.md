# Rails Components

Write reusable components in your rails views. It's not much more than a 
convenient wrapper around rails' `render`.

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

## Configuration

## Examples

[Bootstrap modal][bsmodal] component:

```erb
<%= component 'modal', id: "fun-modal", class: "another-class" do %>
  <%= component 'modal/header_default', "Cool" %>
  <%= component 'modal/body', id: "fun-modal" do %>
    <p>Everyone loves a modal.</p>
  <% end %>
  <%= component 'modal/footer_default', id: "fun-modal" %>
<% end %>
```


## Goals

- make it as easy to write reusable components
- feel familiar to existing rails helpers, like `link_to` or `content_tag` 

## TODO

- tests
- figure out how to make vim-rails jump to files (gf) properly

[bsmodal]: http://v4-alpha.getbootstrap.com/components/modal/
