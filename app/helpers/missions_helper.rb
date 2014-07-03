module MissionsHelper

  def switched_field(field,types)
    classes = switched_field_classes(field,types)
    if classes
      capture do
        yield classes
      end
    end
  end
  def switched_field_classes(field,types)
    types = types.to_a
    requesters = types.select { |type| type.needs_field(field) }
    if requesters.length == types.length
      return "allTypes"
    elsif requesters.length > 0
      return ["switchedField"].concat(requesters.map{ |type| 'for' + type.class_name }).join(' ');
    end
    false
  end
end
