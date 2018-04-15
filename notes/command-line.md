---
title: 'Commandline Memo'
date: '2016-07-14'
description:
categories: []
tags: [anything, Tips, Shell]
position: 7
---

# UNIX 系コマンド Memo （Mac 向け）

## よくやる系

### プロセス確認

    # 全部出力して grep
    $ ps aux | grep hoge

    # ユーザで絞り込む（ww は改行して出力が切れないようにする）
    # * Mac の場合は -u でなくて -U
    $ ps uww -u user_name


## sed : 文字列処理系

    # Mac 版 sed は -i の後にバックアップファイルの拡張子指定が必須
    # （Linux 版だとバックアップ不要の場合は省略できる）
    $ sed -i '.bak' -e 's/OLD/NEW/g' path/to/input_file

    # -e は -f を指定しない場合は省略可能。
    # （-f は編集コマンドを記述したスクリプトファイルの指定）

    # バックアップ作らなくていい場合はこんな感じでよい
    $ sed -i '' 's/OLD/NEW/g' path/to/input_file

- 参考
    - [sedコマンドの備忘録 - Qiita](http://qiita.com/takech9203/items/b96eff5773ce9d9cc9b3)
    - [Macの（BSD版）sed での上書き保存 - Qiita](http://qiita.com/catfist/items/1156ae0c7875f61417ee)

### 複数ファイルの文字列一括置換

    # find コマンドと連携
    $ find ./ -name "*.cpp" | xargs sed -i '' 's/OLD/NEW/g'

    # ag コマンドと連携
    $ ag -l "Hoge" | xargs sed -i '' 's/OLD/NEW/g'


## ネットワーク系

### TCP ポート開いてるか確かめる

- ICMP なら ping でよいけど
- telnet でもよいけど開いてるか確認したいだけなら

        $ nc -vz <host> <port>
        $ nc -vz xx.xx.xx.xx 20-30  # 範囲指定も可

### Mac の電波遮断

ゲーム作ってて電波遮断のテストとかしたくなることあるよね

    $ networksetup -setairportpower en1 off
    $ networksetup -setairportpower en1 on

## 時刻変換・時差計算

- Mac の date は Linux とオプションなどが違う
    - [Macのdateコマンドで時間調整するやり方 - Qiita](http://qiita.com/hid_tgc/items/a82e00112a3683ede528)

```
# 現在時刻から 9 時間後の時刻を表示
$ date -v+9H
```

### UTC → JST

- 案外 date コマンドでサクっとやる方法わからんかった
- 力技でスクリプト言語とかで：

        $ php -r '$t = new DateTime("2016-07-13 12:00:00 UTC"); $t->setTimeZone(new DateTimeZone("Asia/Tokyo")); print $t->format("Y-m-d H:i:s")."\n"; '
        
        2016-07-13 21:00:00

## UNIXTIME 変換

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

## ファイルの MD5 をとる

    # Mac なら標準で md5 コマンドがある
    $ md5 hoge.txt
    MD5 (hoge.txt) = d45ac056aeb47c6bcf5c56dc2b6d3d5c

    # 上記の出力が気に入らないなら
    $ brew install md5sha1sum
    $ md5sum hoge.txt
    d45ac056aeb47c6bcf5c56dc2b6d3d5c hoge.txt

## Human readable を sort したいとき
2009 年以降の Linux の sort には `-h` オプションという素敵なものがあるらしいが
Mac でやるなら `gsort` を使う

    $ brew install coreutils
    $ du -sh * | gsort -h

- [linux - How can I sort du -h output by size - Server Fault](http://serverfault.com/questions/62411/how-can-i-sort-du-h-output-by-size)

## 雑多

### 画像変換

- Mac だと `sips` ってコマンドが便利
    - [sips(1) Mac OS X Manual Page](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/sips.1.html)

____

    # 画像が置かれたディレクトリに移動して一括サイズ変換（横幅を揃える）
    $ for file in *.jpg; do sips --resampleWidth 640 $file --out result/${file%.jpg}.jpg; done

    # -Z オプションは縦横長い方を見てアスペクト比維持で縮小
    # 縦向き・横向きの画像が混ざってるときに便利
    $ sips -Z 640 *.jpg --out result/

