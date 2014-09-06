module ImageHelper
  def image(img_path)
    img_path = img_path.strip
    result_html  = "<div class='image-autofix'>\n"
    result_html += "  <img src='{{urls.media}}/#{img_path}'>\n"
    result_html += "</div>"

    result_html
  end
end

Ruhoh::Views::MasterView.__send__(:include, ImageHelper)
