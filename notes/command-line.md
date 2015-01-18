---
title: 'Commandline Memo'
date: '2014-09-11'
description:
categories: []
tags: [anything, Tips, Shell]
position: 7
---

# UNIX 系コマンド Memo

## UNIXTIME 変換

> ※ Mac の場合

### 日時 → UNIXTIME

    $ date +%s    # 現在時刻 
    1410416640

    $ date -jf '%Y-%m-%d %H:%M:%S' '2014-09-11 15:24:00' +%s
    1410416640

### UNIXTIME → 日時

    $ date -r 1410416640
    2014年 9月11日 木曜日 15時24分00秒 JST

## 画像変換

- Mac だと `sips` ってコマンドがあるらしい

## Mac の電波遮断

ゲーム作ってて電波遮断のテストとかしたくなることあるよね

    networksetup -setairportpower en1 off
    networksetup -setairportpower en1 on


<br/><br/><br/>

