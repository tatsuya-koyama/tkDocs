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

## SSH の公開鍵の fingerprint 確認

    $ ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub

- [SSH-KEYGEN (1)](http://euske.github.io/openssh-jman/ssh-keygen.html)
    - l オプションで表示、f オプションでファイル指定
    - 最近の表示形式は SHA256/base64 らしいので
      MD5/hex で見たい場合は -E オプションでフォーマット指定


## 画像変換

- Mac だと `sips` ってコマンドがあるらしい

## Mac の電波遮断

ゲーム作ってて電波遮断のテストとかしたくなることあるよね

    networksetup -setairportpower en1 off
    networksetup -setairportpower en1 on

## Human readable を sort したいとき
2009 年以降の Linux の sort には `-h` オプションという素敵なものがあるらしいが
Mac でやるなら

    brew install coreutils
    du -hs * | gsort -h

- [linux - How can I sort du -h output by size - Server Fault](http://serverfault.com/questions/62411/how-can-i-sort-du-h-output-by-size)


<br/><br/><br/>

