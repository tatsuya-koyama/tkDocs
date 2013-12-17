---
title: 'Adobe AIR ゲーム開発メモ'
date: '2013-12-16'
description:
categories: []
tags: [anything, Game-Development, krewFramework]
position: 7
---

# Adobe AIR ゲーム開発メモ

## リンク集

- いっぱいあるので後でまとめる


## Feathers どうなの

- [Good]
    - 一通り揃ってる感ある。Starling 用と割り切ってるのもいい

___

- [Not so good?]
    - theme が若干取り込みにくい。 ファイルが embed なのもなぁ。というかデフォルトスキンないのか
        - まあ自分で作れって話なんだろう。でも面倒だな
        - wiki に思想が書いてあった
            - [Why don't the Feathers components have default skins?](http://wiki.starling-framework.org/feathers/faq?&#why_don_t_the_feathers_components_have_default_skins)
        - テーマ使わず自前で作ろうとするとかなりしんどい
            - （いつかできるけど色々調べたり時間かかる。必要なコード量も結構ある）
            - ってかプロパティ多すぎて wiki と API Reference 眺めてもようわからん
            - せいぜい theme のクラス見るけど、これも結構ごっつい
    <br/><br/>
    - ボタンとかのアンカーの指定ってないのかなー

### ハマりポイント

- とりあえず FAQ は読んでおく
    - http://wiki.starling-framework.org/feathers/faq

___

- addChild するフレームで width とか height とるには validate 呼ぶ必要ある
    - まあそれは何となく想像つく
    - validate は addChild 後に呼ぶ必要あるので注意

### 自前テーマ

- わりと自分でどうにかしろ系
    - button.defaultSkin とか downSkin とかに Image 指定してく感じ
        - 個別に指定できるので、まあゲーム開発ならそれでいいか
        - デフォルトだと透明の UI を作ってる感じだ
            - せめてなんか見た目的にわかるもの出してほしかったけどなー
        - Feathers 紹介記事
            - http://cuaoar.jp/2012/11/starling-stage3d-ui-feat.html
    - テーマ初期化用のクラス見れば雰囲気わかる
        - システム系で横断的に使う UI だなーとかなったらこっちにまとめるくらいでいいんじゃね
        - やるなら Embed 使わず、起動シーンでグローバルにアセット読み込んでから getTexture 的なことする

### 便利パーツ

- feathers.display に scale9Image あるね（たぶん 9patch な画像）
    - scale3 もある

## 立ち上げ時の背景色 2〜3 秒出るの気になるよね問題

- [Feathers のサンプルコード](https://github.com/joshtynjala/feathers/blob/master/examples/HelloWorld/source/HelloWorld.as)
  の showLaunchImage() が参考になる
      - Starling の初期化前に Flash の DisplayObject で画像 addChild してる感じかな

<br/><br/><br/><br/>

