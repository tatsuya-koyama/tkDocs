---
title: 'about'
date: '2013-12-06'
description:
categories: []
tags: [anything, ruhoh]
position: 1
---

# 思考ログ

- 何かを作る時の思考の過程とか
- 考えるべきことの洗い出しとか

## 更新履歴

{{# mind-log.collated }}
###{{year}}
<ul>
{{#months}}
  {{#mind-log?to_mind-log}}
  <li>
    <span>{{date}}</span>
    <span style="color: #aaa;">&raquo;</span>
    <a href="{{url}}">{{title}}</a>
  </li>
  {{/mind-log?to_mind-log}}
{{/months}}
</ul>
{{/ mind-log.collated }}

