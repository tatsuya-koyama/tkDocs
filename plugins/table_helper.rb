require 'yaml'

module TableHelper
  def table(sub_context)
    result_html = "<table class='mystyle'>\n"

    table_rows = YAML.load(sub_context)

    row_count = 0
    table_rows.each{|row_array|
      class_name = (row_count == 0) ? 'head' \
                 : (row_count % 2 == 1) ? 'color1' : 'color2'
      result_html += "  <tr class='#{class_name}'>\n"
      row_count += 1;

      col_count = 0
      row_array.each{|cell_data|
        class_name = (col_count == 0) ? 'left' : ''
        col_count += 1
        result_html += "    <td class='#{class_name}'>#{cell_data}</td>\n"
      }

      result_html += "  </tr>\n"
    }

    result_html += "</table>\n"
    result_html
  end
end

Ruhoh::Views::MasterView.__send__(:include, TableHelper)
