---
title: 'ゲーム開発のツールについて'
date: '2014-01-18'
description:
categories: []
tags: [anything, Game-Development]
position: 8
---

# ゲーム開発のツールについて考える

## 自分で作るときの選択肢

### Visual Studio

- Pros
    - C# で書けて素敵
    - 有名どころだし、サポートは最も手厚そう
    - GUI 作るならかなり快適だろう（最近触ってないけど）

___

- Cons
    - **Windows 依存** になる

### Qt

Visual Studio がいいんだけど、Mac でも動かしたい… って人は Qt

- Pros
    - マルチプラットフォーム
    - GUI 作るための GUI がちゃんとある

### Mono

- ってのもある

### Adobe AIR

- Pros
    - マルチプラットフォーム
    - 同じくマルチプラットフォームな AIR でゲーム作るなら、
      AS3 のコードが流用できるなど相性がよい
    - Flash と相性がよい （swf を再生するなど）

___

- Cons
    - コンポーネント組むとき、他ほどよい GUI 環境が無い？
    - FlashBuilder でどこまでできるか知らん

### Unity

- Unity 内にカスタムしたゲーム用ツールを作る
- Unity からそういうものを publish するんじゃなくて、Unity のプラグインを作るってこと
- （何がどこまでできるかはわからん）

___

- Pros
    - GUI が完成している **（特に 3D）**
    - フリー版で十分なため、金がかからない
    - Unity 人気にあやかれる

### Flash や Illustrator からデータを吐き出す

- Flash なら JSFL, Illustrator なら jsx （Adobe ExtensionScript の方）を書いて
  オブジェクトのデータを任意のフォーマットで書き出す
- Flash なら swf をバイナリ解析するという荒技もある

___

- Pros
    - ちょっとした座標データを吐きたいくらいなら手軽
    - もともとアート用のソフトウェアなので **GUI が完成している**
    - Adobe 製品なら広く使われているため、**アーティストが使うときの学習コストが低い**

___

- Cons
    - 有料ソフトが必要

#### 参考リンク

- Adobe の Andy さんがまさにそういうことカンファレンスでやってたけど、GitHub でソース公開してた
    - [GitHub - andyhall / Flash-HTML-demos](https://github.com/andyhall/Flash-HTML-demos/tree/master/4-flash-cocos-level)
- JSFL のドキュメントはここの Extending Flash Professional を見ればいいっぽい
    - [Adobe Flash Professional](http://help.adobe.com/en_US/flash/cs/extend/index.html)
- JSFL 関連
    - [JSFLでjson2.jsライブラリを読みこんだら、すんなり使えたというメモ](http://www.1ft-seabass.jp/memo/2012/11/24/jsfl_tips_004/)


### ゲーム内にエディタを作る

- Pros
    - プレビューを実際にゲーム内で見えるものに近づけやすい
    - データ再生部分のコードをそのまま流用できる

___

- Cons
    - 汎用性はバッサリ切り捨て
    - ツールの GUI を作るのが面倒



## 2D レベルエディタ

### 既製品

- タイル以上のことをやるなら、決定版って知らない
    - みんな自分用にカスタムしたものを作ってるんだと思う
    - ゲームだと汎用的なものを作るのは難しいしね
- Unity 2D とかどうなんだろう

### 自分で作るなら

- JSFL を書いて Flash で配置して好きなフォーマットで出力、がうまくいった
- やはり GUI が完成しているのがありがたい
- コンポーネント定義すれば Flash 上でパラメータ定義も完結する

### タイルマップ

#### Tiled

[Tiled](http://www.mapeditor.org/) は 2D タイルマップなら鉄板

- コンパクトだし無難なデータ吐くだけなので使い勝手がよい
- レイヤーのプロパティを設定したりカスタムのポリゴンも置けるので、割とこれでレベルデザインは完結できる
- かゆいところには手が届かないので、カスタムしたいなら自分で Qt のソースを fork していじる必要あり


## UI レイアウトのエディタ

### 既製品

- 汎用的な決定版は、これも意外と無い
- [SpriteBuilder](http://www.spritebuilder.com/) に期待
    - Cocos2d 向けだがオブジェクトをカスタムすれば他でも使えるかな

### 自分で用意するなら

#### Flash から JSFL で吐く

- 静的なレイアウトだけならこれもレベルエディタと同様 JSFL 書いて位置とか画像名とか吐いてやればよい
    - 特殊な UI はコンポーネント定義して、パラメータと位置と定義する感じ
    - 相対的なレイアウトとかは苦手
    - まあ相対レイアウトって調整が難しいし、それなら複数サイズ分用意しちゃった方がよいかもね

#### Flash から DragonBones で吐く

- 固定サイズで割り切るならアリ
- アニメーションを Flash 上でかなり作り込めるのがいいところ
- UI の制御みたいなのは別途 JSFL で吐くか、DragonBones のラベル名とかで頑張るか、
  プログラムで制御しちゃうか

## 2D アニメーション（ボーン）

### 既製品

#### Flash + DragonBones

- [DragonBones](http://dragonbones.github.io/)
- Adobe 公認。AS3 と JS はすでにサポートされている
    - Cocos2d とかに持ってくなら再生ライブラリ書く必要がある
- 2D アニメーションの大御所の Flash が使えるのは大きい
- **アーティストにとって他の専用ツールより潰しがきく**
- Adobe AIR + Starling でゲーム作るならベストチョイス

#### Spine

- [Spine](http://esotericsoftware.com/) でつくる
- Flash より安い
- Flash の方が慣れてるユーザは多い
- Unity, Cocos2d, Starling など一通りサポートされてる



