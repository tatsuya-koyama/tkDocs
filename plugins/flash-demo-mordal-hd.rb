# -*- coding: utf-8 -*-
require 'yaml'

# Example:
#
# {{# flashModalHD }}
#   id     : flashMordal_globalLayer
#   caption: Play Demo
#   title  : Global Layer
#   swf    : "{{ urls.media }}/swf/krewsample/krew-sample-global-layer.swf"
# {{/ flashModal }}

module FlashDemoModal
  def flashModalHD(sub_context)

    params = YAML.load(sub_context)
    params['caption'] = params['caption'] || "Play Demo"

    result_html = <<EOS
<!-- Button to trigger modal -->
<a href="##{params['id']}" role="button" class="btn flash-modal-btn" data-toggle="modal">
  <img class="btn-icon" src="{{urls.media}}/krewfw/krew_icon_small.png" width="28" height="28" />
  #{params['caption']}
</a>

<!-- Modal -->
<div id="#{params['id']}" class="modal hide fade play-flash-hd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h4 class="flash-modal">#{params['title']}</h4>
    <ul class="flash-modal">
      <li>Required Flash Player 11 or later</li>
    </ul>
  </div>
  <div class="modal-body play-flash-hd">

    <div align="center">
      <object width="900" height="600" data="#{params['swf']}">
        <param name="wmode" value="direct"/>
      </object>
    </div>

  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
EOS
    result_html
  end
end

Ruhoh::Views::MasterView.__send__(:include, FlashDemoModal)
