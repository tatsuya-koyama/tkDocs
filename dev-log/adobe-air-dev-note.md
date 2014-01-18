---
title: 'Adobe AIR ゲーム開発メモ'
date: '2013-12-16'
description:
categories: []
tags: [anything, Game-Development, krewFramework]
position: 9
---

# Adobe AIR ゲーム開発メモ

## リンク集

- [Citrus Engine: Creating Level using Tiled Map Editor](http://pzuh.blogspot.jp/2013/05/citrus-engine-creating-level-using.html)

他にもいっぱいあるので後でまとめる

## Flash CrossBridge ってなに

- [公式](http://adobe-flash.github.io/crossbridge/)
- C / C++ で書いたコードを Flash 向けにコンパイルできるよってやる

### 歴史

- かつて前身となるプロジェクトで [Adobe Alchemy](http://labs.adobe.com/technologies/alchemy/)
  ってのがあった
    - Box2D とか C++ のやつをこれでポーティングした Box2D Alchemy とかあった
    - まあ 2011 年くらいで開発止まってるっぽいけどね
- それが FlasCC （Flash C++ Compiler）というものになった
- Adobe CrossBridge はそれのオープンソース版（2013 年 6 月くらいの発表？）

## 物理エンジンの Nape どうなの

- [Nape Physics Engine](http://napephys.com/index.html)

### いいところ

- ためしてみたけどいい感じ。ヌルヌル動く。
- Box2D よりパフォーマンスいいよってのを謳ってる
- API やコードもすっきりしてていい感じ
    - ただしコードはマクロ満載の haxe だが

### つらいところ

- 使い終わったメモリがどうにも GC 対象になってくれなくて困ってる
    - 実機で動かし続けてたらメモリ消費 150 MB とかいった
    - 破棄したり参照消したりしてもシーン遷移時に回収されない
    - Vec2 のオブジェクトプールの仕様かと思ったが Vec2 使わない Circle とかでもなる
    - ここが解決しないと使えんな

___

- メモリもうちょっと踏み込んで調べてみた
    - どうやらオブジェクト生成・即座に破棄を繰り返すだけだとそんなにリークしない
    - （デバッグで System.gc() 呼べば割と回収される）
    - どちらかというと生成・破棄ではなく物理計算の過程で消費されるメモリが回収しにくいっぽい
    - 400 個とか生成して放り込んでそのまま見てると、それだけでみるみるメモリ消費増えてく
    - ある程度回収されたりもするが、回収しきれず蓄積してく感じ
    - Box2D は Nape より処理重いけど、メモリに関してこういうことはない

___

- Box2D よりマイナーなのが最大の弱点
    - Box2D は C の世界のやつをポーティングしたやつだからね
    - ドキュメントもコミュニティも Nape より強い
- コードが haxe （の独自プリプロセッサ？の caxe とかいうやつ）
    - 汎用言語 haxe から AS3 向けに出力する系なので、深追いするなら結構見たことないコード読まないといけない
    - メモリまわりの解読も結局この辺がネックで諦めた…

## AS3 の Box2D どうなの

- [Demo](http://box2dflash.sourceforge.net/)
- [ドキュメント](http://www.box2dflash.org/docs/2.0.2/manual#Creating_a_World)
- [Box2d Flash Alchemy Port + World Construction Kit](http://www.sideroller.com/wck/)

___

参考リンク
- [Box2D 2.1a Tutorial – Part 1](http://blog.allanbishop.com/box2d-2-1a-tutorial-part-1/)

___

- 個人的にはクラス名とか大文字小文字、細かいレベルでは Nape の方が綺麗で好き
    - ここはさすがに Nape の方が API の切り方とかも AS3 っぽくてよい
    - Nape は単位がメートルじゃなくてピクセルと割り切ってるのも使いやすくてよい
    - Box2D だと毎回表示単位のスケーリングの計算必要になる
- ドキュメンテーションは C++ の本家もあるし、Box2D の方がしっかりしてる感じある

___

- Nape の方が圧倒的にパフォーマンスはよい
    - Box2D だと負荷めっちゃ大きくなったときにガッタガタになってプルプルした動きになる
    - ひどい場合だと静止オブジェクト突き抜ける
    - Nape は重くなってもこのへんの整合性保ってる

### パフォーマンスや挙動

- パフォーマンスは確実に Nape の方が速い。負荷上がったときのガタガタ感も少ない
- Box2D はデバッグビルドだとすぐ重くなるので注意
    - Nape は debug=true でも速かった
- だがメモリ消費は Box2D の方が小さい
    - というか Nape が GC 対象にならず延々とメモリを食い続けてしまう問題がある
    - Box2D ではそんなことはなかった

### ハマったところ

- 以下みたいに type 指定しないと静止オブジェクトのままだった

        bodyDef.type = b2Body.b2_dynamicBody;

- HelloWorld のソース見ても書いてなかったし 2.0.2 のマニュアルにも見当たらなかったので分からんかった
    - って 2.1 で変わったところリストのページがあった。そこ見たら書いてあった

## Feathers どうなの

- [Feathers UI](http://feathersui.com/)

- [Good]
    - 一通り揃ってる感ある。Starling 用と割り切ってるのもいい

___

- [Not so good?]
    - theme が若干取り込みにくい。 ファイルが embed なのもなぁ。というかデフォルトスキンないのか
        - まあ自分で作れって話なんだろう。でも面倒だな
        - wiki に思想が書いてあった
            - [Why don't the Feathers components have default skins?](http://wiki.starling-framework.org/feathers/faq?&#why_don_t_the_feathers_components_have_default_skins)
        - テーマ使わず自前で作ろうとすると割としんどい
            - （いつかできるけど色々調べたり時間かかる。必要なコード量も結構ある）
            - ってかプロパティ多すぎて wiki と API Reference 探しまわる必要あり
            - theme のクラス見ればいいんだけど、これも結構ごっつい
    <br/><br/>
    - ボタンとかのアンカーの指定ってないのかなー

### ハマりポイント

- とりあえず FAQ は読んでおく
    - http://wiki.starling-framework.org/feathers/faq

___

- addChild するフレームで width とか height とるには validate 呼ぶ必要ある
    - まあそれは何となく想像つく
    - validate は addChild 後に呼ぶ必要あるので注意

### 悩みポイント

- 見た目整えようとするとなんだかんだコード量多くなる
    - 大規模開発で使うならこのへんの設定ファイル吐き出す Builder みたいなものが
      結局ほしくなっちゃうと思う

___

- フォント使うリストだと結構 Draw Call の数くっちゃうよね
    - [リスト試してみたやつ](/krew-framework/feature-demo)
    - 20 くらいいっちゃうのはさすがに見過ごせない
    - 画面外のアイテムとかは Draw Call 食ってないのでそこはまあ大丈夫

___

- リストアイテムで各セルごとにテクスチャ変えるとかは無理？

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
    - UI じゃなくても使いどころありそう


## 立ち上げ時の背景色 2〜3 秒出るの気になるよね問題

- [Feathers のサンプルコード](https://github.com/joshtynjala/feathers/blob/master/examples/HelloWorld/source/HelloWorld.as)
  の showLaunchImage() が参考になる
      - Starling の初期化前に Flash の DisplayObject で画像 addChild してる感じかな

## 画像の解像度って

- できるだけ 1 枚にまとめたいけど、どれくらいのサイズまで安定して使えるんだっけ？
    - 要は端末の OpenGL のスペックによりけりだろうけど
    - Android がどれくらい 2048 x 2048 を許容できるか、がキモかな
    - 1024 x 1024 なら大抵大丈夫だからそれで頑張るか
        - その場合 960 x 640 の背景画像はそれだけで 1 枚みたいになっちゃうけど、まあ背景ならいいか

## Starling 使って思ったこと

### パフォーマンス

- シンプルさを重視してて、そこまでパフォーマンスにこだわっていない感じ
    - 空間分割とかそういうのは無いっぽい。でかい DisplayTree は普通に重くなる（全部走査してる）
    - 走査中に alpha = 0 とか visible = false だったら行列計算の処理飛ばすくらいはやってる
    - width とか height の getter で重い行列計算が走る罠があるので注意

### タッチイベント

- DisplayObject のサイズとかで一思いにやっちゃってるのは初心者フレンドリーだけど扱い辛い
    - あと指でさわるとツリー上の全 DisplayObject なめるみたいで処理負荷大きかったのがイケてない
    - だから krewFramework では Actor はデフォルト touchable = false にした
- 関連した議論がここでされてる
    - http://forum.starling-framework.org/topic/rendering-performance-will-many-children

## Starling でタイルマップ効率よく描画するには

- 2 レイヤーくらいで合計 100 タイルくらいだったら各レイヤー QuadBatch すれば問題なさそう
- 当然だけど reset & addImage する頻度減らすほど効率よくなる
- とすると、ちっちゃいタイルを数百タイル表示したいような場合は？
    - 画面の数分の 1 くらいの領域のタイルごとに QuadBatch にまとめる
    - スクロールで入ってくる新しい領域ぶんだけ新しく QuadBatch を構成（他はスクロールだけ）

## Starling Topics

### たくさんスプライト出したい系

- [ImageBatch](https://github.com/elsassph/starling-imagebatch)
    - 公式にのってない Extension
    - こまかいパーティクル描画に使える
    - このデモたしかにパフォーマンスすごい

___

- [QuadtreeSprite](http://wiki.starling-framework.org/extensions/quadtreesprite)
    - 四分木で見えてるとこだけ DisplayList にのっけるようなスプライト
    - 広大なタイルマップ描画とかに使える


## FlexUnit どうなの

- なんかバージョン色々あったり、1 年前にダウンロードした場所がなくなってたり、
  最新版っぽいのがドキュメントの URL 切れてたりで色々と切ない

### 参考リンク

- 最小構成で動かしたいときに以下が参考になった。
  古めの記事だけど新しいやつなんかうまく動かないし…
    - [FlexUnit4が使いたくなった。 (2009-6)](http://prepro.wordpress.com/2009/06/10/flexunit4%E3%81%8C%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%8F%E3%81%AA%E3%81%A3%E3%81%9F%E3%80%82/)


## メモリのマネジメント

### GC

- Scout とか Starling のモニター見てたりする感じだと、律儀に null 入れてやったりするのは効果ありそう
    - System.gc() 呼んだときに解放されないものでも、時間が経つと解放されたりするので gc() 信用してはダメ
    - 循環参照してても、基本的に ROOT から辿れないものは GC 対象になるっぽいが、
      あまりに複雑に循環してる固まりが ROOT から浮いた状態になってると、GC は「諦める」らしい
    - お互い参照してるところ（何かを登録する系だとよくある）ではインスタンス破棄時に null 入れてあげよう

#### 参考リンク

- [Understanding Garbage Collection in AS3](http://flashvideotrainingsource.com/featured_post/hints-and-tips/understanding-garbage-collection-in-as3)

### インスタンスの消費メモリ

- flash.sampler.getSize(obj) で obj のメモリサイズ（Byte）がとれるよ！



<br/><br/><br/><br/>

