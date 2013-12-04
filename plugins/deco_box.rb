module DecoBox
  def hint_box(sub_context)
    "<div class='hint-box'>#{sub_context}</div>"
  end
end

Ruhoh::Views::MasterView.__send__(:include, DecoBox)
