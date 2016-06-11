---
title: 'about'
date: '2013-12-21'
description:
categories: []
tags: [anything, English]
position: 1
---

# About

- 特に英語関連で勉強したことをメモっておくところ
- 主に技術英語やプログラマ向け
- 自分でも使えるように世のドキュメンテーションのフレーズをメモったりとか

## 関連リンク

- [英語関連のブックマーク](/bookmark/english)


## 更新履歴

{{# english.collated }}
###{{year}}
<ul>
{{#months}}
  {{#english?to_english}}
  <li>
    <span>{{date}}</span>
    <span style="color: #aaa;">&raquo;</span>
    <a href="{{url}}">{{title}}</a>
  </li>
  {{/english?to_english}}
{{/months}}
</ul>
{{/ english.collated }}


