# Rails Components

write reusable components in your rails views. a thin wrapper around `render`
that makes passing blocks, and html attributes to templates simple as pie.

## Installation

get the gem

```rb
gem 'rails_components'
```

and make the `component` helper available in your views

```rb
module ApplicationHelper
  include RailsComponents
end
```

## Usage

a component is a template

```erb
<!-- app/views/components/_my_cool_component.html.erb -->
<div class="my-cool-component">Hello!</div>
```

a component can yield, and you can pass a block to it

```erb
<!-- app/views/components/_my_cool_component.html.erb -->
<div class="my-cool-component"><%= yield %></div>
```

```erb
<!-- in a view -->
<h1>My website!</h1>
<%= component 'my_cool_component' do %>
  <p>It's great.</p>
<% end %>
```

or pass it an argument instead of a block, like `link_to` or `content_tag`

```erb
<!-- in a view -->
<%= component 'my_cool_component', "It's great." %>
```

they live in `app/views/components` by default.

components have a special method: `props`.  `props` is the same as the
template's local variables, except it includes reserved words.
This makes it useful for passing html attributes like `class`.

```erb
<!-- component -->
<%= content_tag :div, props do %>
  <%= yield %>
<% end %>

<!-- in a view -->
<%= component 'box', class: "box", data: { foo: 'bar' } do %>
  <p>my box!</p>
<% end %>
```

```html
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

<!-- in a view -->
<%= component 'box', class: "big" do %>
  <p>my big box!</p>
<% end %>
```

```html
<!-- output -->
<div class="big box">
  <p>my big box!</p>
</div>
```

if you're using haml, it already does this for you, and you can use props directly:

```haml
/ component
.box{ props }
  = yield
```


## Bigger Examples

### [Bootstrap modal](http://v4-alpha.getbootstrap.com/components/modal/)

```erb
<!-- in a view -->
<%= component 'modal', id: "important-message", class: "my-fancy-modal" do %>
  <%= component 'modal/header', "Cool" %>
  <%= component 'modal/body' do %>
    <p>
      Some important stuff!
    </p>
  <% end %>
  <%= component 'modal/footer' %>
<% end %>
```

```erb
<!-- components -->

<!-- app/views/components/_modal.html.erb -->
<%= content_tag :div, props.html(class: 'modal fade', tabindex: '-1', role: 'dialog') do %>
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <%= yield %>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
<% end %>

<!-- app/views/components/modal/_header.html.erb -->
<%= component 'modal/header_container' do %>
  <%= component 'close_button', data: { dismiss: "modal" } %>
  <%= component 'modal/title' do %>
    <%= yield %>
  <% end %>
<% end %>

<!-- app/views/components/modal/_header_container.html.erb -->
<%= content_tag :div, props.html(class: "modal-header") do %>
  <%= yield %>
<% end %>

<!-- app/views/components/modal/_title.html.erb -->
<%= content_tag props.fetch(:tag, "h4"), props.html(class: "modal-title").except(:tag) do %>
  <%= yield %>
<% end %>

<!-- app/views/components/_close_button.html.erb -->
<%= content_tag :button, props.html(type: 'button', class: 'close', :"aria-label" => 'close' ) do %>
  <span aria-hidden="true">&times;</span>
<% end %>

<!-- app/views/components/modal/_body.html.erb -->
<%= content_tag :div, props.html(class: 'modal-body') do %>
  <%= yield %>
<% end %>

<!-- app/views/components/modal/_footer.html.erb -->
<%= component 'modal/footer_container', props do %>
  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
  <%= yield %>
<% end %>

<!-- app/views/components/modal/_footer_container.html.erb -->
<%= content_tag :div, props.html(class: "modal-footer") do %>
  <%= yield %>
<% end %>
```

```html
<!-- output -->
<div id="important-message" class="my-fancy-modal modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button data-dismiss="modal" type="button" class="close" aria-label="close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title">Cool</h1>
      </div>
      <div class="modal-body">
        <p>Some important stuff!</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div>
```


### A navbar, based off of the [basscss guide](http://www.basscss.com/v7/docs/guides/ui/#navbars)

```
<!-- in a view -->
<%= component 'navbar', class: "white bg-green" do %>
  <div class="left">
    <%= component 'navbar/item', "Burgers", href: "#!" %>
    <%= component 'navbar/item', "An example", href: "#!", class: "btn-narrow" %>
  </div>
  <div class="right">
    <%= component 'navbar/item', "My Account", href: "#!" %>
  </div>
  <div class="overflow-hidden px2 py1">
    <%= component 'input', name: "whatever", class: "right m0 fit bg-darken-1", placeholder: "Search" %>
  </div>
<% end %>
```

```erb
<!-- app/views/components/_navbar.html.erb -->
<%= content_tag :div, props.html(class: "clearfix mb2") do %>
  <%= yield %>
<% end %>
```

```erb
<!-- app/views/components/navbar/_item.html.erb -->
<%= link_to href, props.html(class: "btn m0 py2") do %>
  <%= yield %>
<% end %>
```

## How this compares to `render`

`component` is a wrapper around `render` [under the hood](./lib/rails_components.rb):

```erb
<%= component 'modal', title: "Example" do %>
  Modal content!
<% end %>
```

```erb
<%= render layout: 'component/modal', locals: { title: "Example" } do %>
  Modal content!
<% end %>
```

Where it shines is taking arguments instead of blocks

```erb
<%= component 'modal', 'Modal content!', title: "Example" do %>
```

And allowing you to use reserved words, which doesn't work with render

```erb
<!-- won't work! rails can't make `class` a local variable -->
<%= render layout: 'component/modal', locals: { class: "fancy-modal" } do %>
  Modal content!
<% end %>
```

```erb
<!-- works! -->
<%= component 'modal', 'Modal content!', class: "fancy-modal" do %>
```

## Motivation

Working on rails apps where the same css class declarations were repeated
many times over, making changing common components very difficult. This
type of abstraction is very helpful when using functional/atomic/utility css classes.

From the [basscss docs](http://www.basscss.com/v7/docs/guides/tips/#handle-complexity-in-markup):

> Large projects will inevitably become more complex. Handling and
> maintaining that complexity in markup templates is much easier than
> adding complexity to your stylesheet. Before abstracting combinations
> of styles out in to new styles, make sure to look for patterns and
> think about reusability, and consider ways in which your templating
> engine can DRY up your code. If you’re constantly duplicating the
> same markup to create UI elements like media player controls or
> modals, make use of things like partials, helpers, or __components__
> to keep things maintainable.

(emphasis added)


## Configuration

TODO

## What's the future of this project, will it be maintained, etc

Hard to say. If you're worried about dependencies, copy it into your project
as a helper. render's api is probably not getting any big changes, so hopefully
this project creates a minimal amount of headaches.

This project's goal is to act as documentation and examples of how to write
components in a rails app (as opposed to adhoc files in `app/views/shared`.)


## TODO

- tests
- test configuration
- figure out how to make vim-rails jump to files (gf) properly
- point out that mixing erb and haml has issues

