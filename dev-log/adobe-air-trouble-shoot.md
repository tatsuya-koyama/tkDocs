---
title: 'Adobe AIR トラブルシュート'
date: '2014-05-07'
description:
categories: []
tags: [anything, Game-Development, Adobe-AIR]
position: 10.1
---

# Adobe AIR トラブルシュート メモ

- **※ シュートしきれてないメモも含みます**

## 2014-06-09: AS3 の無名関数のメモリ消費

- AS3 で無名関数使うとなんか思った以上にメモリ消費してた
- クロージャが変数キャプチャするからだろうけどそれでも思った以上

        // これで 798 (byte) とか返ってくる。
        // 普通のクラスのインスタンスで 50 とかなのに
        flash.sampler.getSize(
            function():void {}
        );

___

- 例えばよく呼ばれるところに何も副作用のない以下のコードを書いただけで、
  目に見えてメモリ消費していく

        for (var i:int=0;  i < 100;  ++i) {
            var foo:Function = function():void {};
        }

___

- このメモリはちゃんと GC で回収されるけど、それは GC を起こしてしまうってことだ
- とはいえ無名関数なんて普通に使いたくなるので困ったちゃん
- 回避策探してる

### 参考リンク

- [(1) AS3のクロージャ](http://www.imajuk.com/blog/archives/2008/04/as3_2.html)
- [(2) アクティベーションオブジェクトとスコープチェーン](http://www.imajuk.com/blog/archives/2008/04/post_4.html)
- [(3) アクティベーションオブジェクトによるメモリリーク](http://www.imajuk.com/blog/archives/2008/04/post_3.html)


## 2014-05-21: Xcode の IOKit 無いって言われる

- AIR というより Xcode の SDK のレベルの問題
- FlashBuilder での iOS 実機デバッグ時に以下のようなエラー出た

        アプリケーションのパッケージ化中にエラーが発生しました :
        
        ld: framework not found IOKit
        Compilation failed while executing : ld64

___

- 以下 Stack Overflow 参考
    - http://stackoverflow.com/questions/17542092/iokit-not-found
- シンボリックリンクはったら動いた

        # 見やすさのために改行入れてます
        cd /Applications/Xcode.app/Contents/Developer/Platforms
           /iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
           /System/Library/Frameworks/IOKit.framework
        sudo ln -s Versions/A/IOKit .


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



