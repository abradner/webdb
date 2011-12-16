module RawFilesHelper
  def custom_field_for_schema(model, fms)
    label = model << '[' << fms.label << ']'
    case fms.field_type
      when "DateTime"
        datetime_select model, fms.label
      when "Date"
        date_select model, fms.label
      when "Time"
        time_select model, fms.label
      when "Char"
        text_field_tag label, "", :size => 1, :maxlength => 1
      when "String"
        text_field_tag label, "", :max_length => fms.field_value
      when "Text"
        text_area_tag label
      when "Multi"
        if fms.select_options.blank?
          return "No options configured"
        else
          html = ""
          fms.select_options.each do |opt|
            html << "<span class='radio_button'>" << label_tag(label + "_" + opt['value'], opt['value'], :class => 'radio_label')
            html << check_box_tag(label, opt['value'], opt['selected'], :id => sanitize_to_id(label + "_" + opt['value'])) << "</span>"
          end
          return html.html_safe
        end
      when "Radio"
        if fms.select_options.blank?
          return "No options configured"
        else
          html = ""
          fms.select_options.each do |opt|
            html << "<span class='radio_button'>" << label_tag(label + "_" + opt['value'], opt['value'], :class => 'radio_label')
            html << radio_button_tag(label, opt['value'], opt['selected']) << "</span>"
          end
          return html.html_safe
        end
      when "Select"
        options = Array.new
        selected = nil
        fms.select_options.each do |opt|
          options << opt['value']
          selected = opt['value'] if opt['selected'].eql?(true)
        end
        if fms.select_options.blank?
          return "No options configured"
        else
          return select_tag label, options_for_select(options, selected)
        end

      when "Integer"
        text_field_tag label, ""
      when "Float"
        text_field_tag label, ""
      else
        "Unrecognised Metadata Type"
    end
  end
end
