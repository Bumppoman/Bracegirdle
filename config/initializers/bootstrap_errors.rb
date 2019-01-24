ActionView::Base.field_error_proc = proc do |html_tag, instance|
  class_attr_index = html_tag.index 'class="'

  if class_attr_index
    html_tag.insert class_attr_index + 7, 'is-invalid '
  else
    html_tag.insert html_tag.index('>'), ' class="is-invalid"'
  end

  html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

  form_fields = [
      'textarea',
      'input',
      'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(<div class="control-group error">#{e}</div>).html_safe
    elsif form_fields.include? e.node_name
      if instance.error_message.kind_of?(Array)
        html = %(#{html_tag}<span class="invalid-feedback">#{instance.error_message.uniq.join(', ')}</span>).html_safe
      else
        html = %(#{html_tag}<span class="invalid-feedback">#{instance.error_message}</span>).html_safe
      end
    end
  end
  html
end
