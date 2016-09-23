module RailsComponents
  COMPONENT_RESERVED_WORDS = %i(class return super).freeze

  def component(component_template, text_or_locals_with_block = nil, locals = nil, &block)
    if block_given?
      render({ layout: component_template, locals: component_locals(text_or_locals_with_block) }, &block)
    else
      render(layout: component_template, locals: component_locals(locals)) { text_or_locals_with_block }
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
    locals.except(*COMPONENT_RESERVED_WORDS).merge(props: locals)
  end
end
