# Rails Components

Write reusable components in your rails views.

## Installation

Install the rails components gem by adding it to your Gemfile:

```rb
gem 'rails_components'
```

and make the `component` helper available in your views:

```rb
module ApplicationHelper
  include RailsComponents
end
```

## Usage

A component is a template that yields, in `app/views/components` by default

```erb
<!-- app/views/components/_my_cool_component.html.erb -->
<div class="my-cool-component">
  <%= yield %>
</div>
```

You can call `component 'the_component_name'` and pass it a block, and it works
like `render layout: ...`.

```erb
<div>
  <h1>My website!</h1>
  <%= component 'my_cool_component' do %>
    <p>It's great.</p>
  <% end %>
</div>

<!-- output: -->
<div>
  <h1>My website!</h1>
  <div class="my-cool-component">
    <p>It's great.</p>
  </div>
</div>
```

If you're just passing a string to your component, you can pass them an
argument instead of a block, like `link_to` or `content_tag`:

```erb
<%= component 'my_cool_component', "It's real good." %>

<!-- output: -->
<div class="my-cool-component">
  It&#39;s real good.
</div>
```

Sometimes your component doesn't need anything at all

```
<%= component 'logo' %>

<!-- output: -->
<div class="brand">
  <img src="logo.gif" alt="Us!" />
</div>
```

Components are given access to a special method: `props`.
`props` is the same as `local_assigns` except it includes reserved words like
`class`, making it useful for passing html attributes.

```erb
<!-- component -->
<%= content_tag :div, props do %>
  <%= yield %>
<% end %>

<!-- within any view: -->
<%= component 'box1', class: "box", data: { foo: 'bar' } do %>
  <p>my box!</p>
<% end %>

<!-- output -->
<div class="box" data-foo="bar">
  <p>my box!</p>
</div>
```

`props` has a method called `html` which combines it with additional html attributes:

```erb
<!-- component -->
<%= content_tag :div, props.html(class: "box") do %>
  <%= yield %>
<% end %>

<!-- output -->
<div class="big box">
  <p>my big box!</p>
</div>
```

If you're using haml, it already does this for you, and you can use props directly:

```haml
.box{ props }
  = yield
```


## Bigger Examples

[Bootstrap modal][bsmodal]:

```erb
```

[Basscss navigation]

## Configuration

TODO

## Goals

- make it as easy to write reusable components
- feel familiar to existing rails helpers, like `link_to` or `content_tag`

## TODO

- tests
- figure out how to make vim-rails jump to files (gf) properly
- point out that mixing erb and haml has issues

[bsmodal]: http://v4-alpha.getbootstrap.com/components/modal/
[bspanel]: http://v4-alpha.getbootstrap.com/components/card/
