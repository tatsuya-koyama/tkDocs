# coding: utf-8
require 'yaml'

# 書き方
# * data.yaml に以下のようなデータを記述しておく：
# notes:
#   engineering:
#     - software-engineering
#     - algorithm
#     - data-structure
#     - git
#     - command-line
#   phycology:
#     - phycology/see
#     - phycology/think
#     - phycology/motivation
#     - phycology/feeling
#     - phycology/error
#   ...
#
# * notes/ 以下が対象であれば、
# {{# layout_index }}
#   collection: notes
#   indices:
#     -
#       - engineering
#       - エンジニアリング
#     -
#       - phycology
#       - ユーザ心理
# {{/ layout_index }}
#
module LayoutIndexHelper
  def layout_index(sub_context)
    result_html = "<div class='accordion' id='accordion2'>\n"

    data = YAML.load(sub_context)

    row_count = 0
    data['indices'].each{|index_data|
      tag     = index_data[0]
      caption = index_data[1]
      result_html += _get_accordion_item(data['collection'], tag, caption, row_count)
      row_count += 1
    }

    result_html += "</div>\n"
    result_html
  end

  def _get_accordion_item(collection_name, tag, caption, row_count)
    <<"EOS"
    <div class="accordion-group">

        <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion2" href="#collapse_#{row_count}">
                #{caption}
            </a>
        </div>
        <div id="collapse_#{row_count}" class="accordion-body collapse">
            <div class="accordion-inner">
                <ul>
                  {{#data.#{collection_name}.#{tag}?to_notes}}
                    {{> page-list.html }}
                  {{/data.#{collection_name}.#{tag}?to_notes}}
                </ul>
            </div>
        </div>
    </div>
EOS
  end
end

Ruhoh::Views::MasterView.__send__(:include, LayoutIndexHelper)
