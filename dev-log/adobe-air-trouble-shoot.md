---
title: 'Adobe AIR トラブルシュート'
date: '2014-05-07'
description:
categories: []
tags: [anything, Game-Development, Adobe-AIR]
position: 10.1
---

# Adobe AIR トラブルシュート メモ

## 2014-05-07: なんか Android ビルドで dx tool failed

- ANE とか増やしたり AIR 13 にバージョンアップしたりしてたら、
  いつの間にか apk のビルドでこんなエラー出るように
- （iOS のビルドは問題なかった）

        dx tool failed:
        UNEXPECTED TOP-LEVEL ERROR:
        java.lang.OutOfMemoryError: Java heap space
            at java.util.ArrayList.<init>(ArrayList.java:112)
            ...

___

- まあ JVM のメモリ食うようになったんだろう
- ヒープサイズのデフォルトっていくらくらいの設定？

> 【参考】[JVMヒープサイズのデフォルト値は？](http://tech.ewdev.info/2012/01/298/)
>
> ・J2SE 5.0以降 <br/>
> 初期値：物理メモリの 1/64 <br/>
> 最大値：物理メモリの 1/4（上限1GB） <br/>
> （物理メモリが1GBより小さい場合、最大値は物理メモリの1/2） <br/>

- メモリ 8 GB だと 128 MB ってことか
- ビルドコマンドに以下を挟んで最大値を 256 MB に設定してみる

        export _JAVA_OPTIONS="-Xmx256M"; \
        adt -package -target apk-captive-runtime ...

___

- ビルド成功した
- 【参考】この人も同じ問題に遭遇してヒープサイズ広げて解決してる：
    - [Flash Error Message: “dx tool failed … java heap size” – SOLUTION](http://www.0x101010.com/flash-error-message-solution/?utm_source=rss&utm_medium=rss&utm_campaign=flash-error-message-solution)



