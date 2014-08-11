---
title: '既知の問題'
date: '2014-08-11'
description:
categories: []
tags: [anything, krewFramework]
position: 1
---

# 既知の問題

ごめんなさい、いつか直します

## 2014-08-11: KrewSystemEventType.SYSTEM_DEACTIVATE の呼ばれるタイミング

- 本来 SYSTEM_DEACTIVATE はアプリの Suspend 時に呼ばれる想定だったけど、
  うまく呼ばれていない
- 今は Resume 時に Suspend -> Resume が呼ばれちゃっている
- メッセージングはバックグラウンドに入った瞬間も動くように書いたつもりだったけど、
  そもそも Resume すると ENTER_FRAME イベントが呼ばれず mainLoop 入ってこなかった





