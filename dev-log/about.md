---
title: 'about'
date: '2013-12-01'
description:
categories: []
tags: [anything, ruhoh]
position: 1
---

# 開発ログ

- 何かを作った時の作業ログとか
- 開発で得た個人的な知見のメモ

## 更新履歴

{{# dev-log.collated }}
###{{year}}
<ul>
{{#months}}
  {{#dev-log?to_dev-log}}
  <li>
    <span>{{date}}</span>
    <span style="color: #aaa;">&raquo;</span>
    <a href="{{url}}">{{title}}</a>
  </li>
  {{/dev-log?to_dev-log}}
{{/months}}
</ul>
{{/ dev-log.collated }}

