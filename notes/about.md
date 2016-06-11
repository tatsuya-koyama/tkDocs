---
title: 'about'
date: '2013-12-01'
description:
categories: []
tags: [anything, ruhoh]
position: 1
---

# 勉強ノート

- 勉強したことをメモっておくところ
- 開発メモと違って、一般的な知識として世の中に知られているものを自分用にまとめるところ

## 更新履歴

{{# notes.collated }}
###{{year}}
<ul>
{{#months}}
  {{#notes?to_notes}}
  <li>
    <span>{{date}}</span>
    <span style="color: #aaa;">&raquo;</span>
    <a href="{{url}}">{{title}}</a>
  </li>
  {{/notes?to_notes}}
{{/months}}
</ul>
{{/ notes.collated }}

