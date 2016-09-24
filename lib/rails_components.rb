require 'rails_components/html_helpers'
require 'rails_components/configuration'

module RailsComponents
  COMPONENT_RESERVED_WORDS = %i(class return super).freeze

  def component(component_template, text_or_locals_with_block = nil, locals = nil, &block)
    if RailsComponents.configuration.template_directory
      component_template = [RailsComponents.configuration.template_directory, component_template].join('/')
    end

    if block_given?
      render({ layout: component_template, locals: component_locals(text_or_locals_with_block) }, &block)
    elsif text_or_locals_with_block.is_a?(Hash) && locals.nil?
      render(layout: component_template, locals: component_locals(text_or_locals_with_block)) {}
    else
      render(layout: component_template, locals: component_locals(locals)) { text_or_locals_with_block }
    end
  end

  # references:
  # - https://github.com/rails/rails/blob/v5.0.0/actionview/lib/action_view/helpers/tag_helper.rb#L104
  def component_content_tag(props, name, content_or_options_with_block = nil, options = nil, escape = true, &block)
    if block_given?
      content_or_options_with_block = props.merge_html(content_or_options_with_block) if content_or_options_with_block.is_a? Hash
      content_tag(name, content_or_options_with_block, options, escape, &block)
    else
      options = props.merge_html(options)
      content_tag(name, content_or_options_with_block, options, escape, &block)
    end
  end

  private

  # because rails does some weird stuff to make it easy to access the locals in
  # templates, this strips out any problem-causing key names (e.g. "class"),
  # but gives you a new local, "prop" that has access to all the locals that
  # were passed in (including the stripped out ones)
  #
  # references:
  # - https://github.com/rails/rails/blob/master/actionview/lib/action_view/template.rb
  def component_locals(locals)
    locals ||= {}
    locals.extend(HtmlHelpers)
    locals.except(*COMPONENT_RESERVED_WORDS).merge(props: locals)
  end
end
