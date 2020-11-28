class BracegirdleFormBuilder < ActionView::Helpers::FormBuilder
  INPUT_DEFAULTS = { class: 'form-control' }
  
  def date_field(m, options = {})
    wrapped_text_field(:date_field, m, options)
  end
  
  def email_field(m, options = {})
    wrapped_text_field(:email_field, m, options)
  end
  
  def label(method, text = nil, options = {})
    text == false ? ''.html_safe : super(method, text, class: 'form-control-label')
  end
  
  def money_field(m, options = {})
    wrapped_output(options[:required]) do
      output = <<-MONEY
        #{label m, options[:label], options}
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">
              <i class="material-icons tx-16 lh-0 op-6">attach_money</i>
            </span>
          </div>
          #{ method(:text_field).super_method.call(m, options.merge({ class: 'form-control' })) }
        </div>
      MONEY
      
      output.html_safe
    end
  end
  
  def number_field(m, options = {})
    wrapped_text_field(:number_field, m, options)
  end
  
  def phone_field(m, options = {})
    wrapped_text_field(:phone_field, m, options)
  end
  
  def question_field(m, options = {})
    output = <<-QUESTION
      <div class="row">
        <div class="col-md-6">
          <div class="form-group">
            #{label m, options[:label], options}
            <div class="yesno">
              <span class="question">
                #{radio_button m, true}
                <span>Yes</span>
              </span>
              <span class="question">
                #{radio_button m, false, checked: !object.send(m)}
                <span>No</span>
              </span>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          #{text_field(
              options.fetch(:comments_field_name, m.to_s + '_comments'), 
              label: options.fetch(:comments_label, 'Comments'),
              value: object.send(options.fetch(:comments_field_name, m.to_s + '_comments')).presence || 
                options.fetch(:default, '')
            )}
        </div>
      </div>
    QUESTION

    output.html_safe
  end

  def select(method, choices = nil, options = {}, html_options = {})
    wrapped_output(options[:required]) do
      label(method, options[:label]) +
      super(method, choices, options, input_options(html_options, 
        { class: "form-control#{' choices-basic' unless options[:without_choices]}" }))
    end
  end
  
  def text_area(m, options = {})
    wrapped_text_field(:text_area, m, options)
  end
  
  def text_field(m, options = {})
    wrapped_text_field(:text_field, m, options)
  end
  
  def time_field(m, options = {})
    @template.tag.div(
      class: "form-group#{' required' if options[:required]}",
      data: {
        controller: 'timepicker'
      }
    ) do
      label(m, options[:label]) +
      method(:text_field).super_method.call(
        m, 
        input_options(
          options.merge(
            {
              data: {
                target: 'timepicker.originalInput'
              }
            }
          )
        )
      ) +
      help_text(options[:help_text])
    end
  end

  private
  
  def help_text(text)
    @template.tag.small(text, class: 'form-text text-muted') if text
  end
  
  def input_options(options, defaults = nil)
    defaults ||= INPUT_DEFAULTS
    
    (defaults.keys + options.keys).inject({}) do |h, key|
      if key == :data
        h[key] = options[key]
      elsif key == :label
        h
      else
        h[key] = [defaults[key], options[key]].compact.join(' ')
      end
      
      h
    end
  end
  
  def wrapped_output(required, &content)
    @template.tag.div class: "form-group#{' required' if required}" do
      yield
    end
  end
  
  def wrapped_text_field(type, form_method, options = {})
    @template.tag.div class: "form-group#{' required' if options[:required]}" do
      label(form_method, options[:label]) +
      method(type).super_method.call(form_method, input_options(options)) +
      help_text(options[:help_text])
    end
  end
end