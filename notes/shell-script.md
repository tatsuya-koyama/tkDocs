---
title: 'ShellScript Memo'
date: '2016-06-09'
description:
categories: []
tags: [anything, Tips, Shell]
position: 7
---

# シェルスクリプト Memo

## 参考リンク

- [これだけ覚えておけばOK！シェルスクリプトで冪等性を担保するためのTips集 - Qiita](http://qiita.com/yn-misaki/items/3ec0605cba228a7d5c9a)

## 変数のデフォルト値（空だったらデフォルト値を入れる）

    # VAR が空なら "default value" をセット
    VAR=${VAR:="default value"}

- 参考： [Bashシェルの変数にデフォルト値を設定する - My Octopress Blog](http://buf-material.github.io/blog/2014/10/11/set-default-value-to-bash-variables/)

<br/><br/><br/>

