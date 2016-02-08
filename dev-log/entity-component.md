---
title: 'Component 指向'
date: '2015-09-06'
description:
categories: []
tags: [anything, krewFramework]
position: 113
---

# Component 指向のフレームワークを考える

Updated at: 2015-09-06

## とりあえずこんなの作った

- 2D と 3D の View を同時に扱うテスト
- 1 つの Stage3D インスタンスで Starling / Away3D / Starling の描画レイヤーを扱う

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/dev-log/integrate_stage3d.jpg"
       style="width: 100%; max-width: 640px;" />
</div>

<div class="clearfix"></div><br/>

{{# flashModalHD }}
  id     : flashMordal_HD
  caption: Play Demo (HD)
  title  : Integrating Starling and Away3D
  swf    : "{{ urls.media }}/swf/lab/integrate_starling_away3d.swf"
{{/ flashModalHD }}

{{# flashModal }}
  id     : flashMordal_SD
  caption: Play Demo (SD)
  title  : Integrating Starling and Away3D
  swf    : "{{ urls.media }}/swf/lab/integrate_starling_away3d.swf"
{{/ flashModal }}

<div class="clearfix"></div>

<a href="https://github.com/tatsuya-koyama/frameworkLab/tree/master/integrate_away3d_starling"
   class="btn large-btn clearfix"
   style="float: right; margin: 1.0em 1.0em 0 0;">
  <img class="btn-icon" src="{{urls.media}}/krewfw/GitHub-Mark-64px.png" width="28" height="28" />
  Source Code
</a>
<div class="clearfix"></div>

- こういうのをスマートに書きたい
- Entity に対して 2D の見た目が必要なら 2DView を、
  3D なら 3DView を attach する感じで、見た目に関係なく同等に扱いたい

## krewFramework の反省点

前に作った Actor モデルのフレームワーク
[krewFramework](/krew-framework/top) について

### よいところ

- オブジェクト主体の考え方は人間にはわかりやすい
- 各機能や部品を Actor とそのメッセージングで提供することで、共通のインタフェースで扱える
    - 必要ない Actor は使わなければいいだけなのでフレームワークレイヤーが太らない
- 便利メソッドを Actor に詰め込むことで、コーディングが手軽に
- Scene に必要なリソースを宣言的に書ける

### 改善点

- 便利メソッドを Actor に詰め込みたくなるので、よくある **ベースクラスでかくなる問題** が起こる
    - 最小の構成要素はもっと小さくしたい（メモリ的にも）
- 割り切りのつもりだったが、**Actor が Starling の Sprite** だったのはよくない設計だった
    - View を持つ必要が無い Actor はいっぱいいる
    - 3D も同じように扱いたい、と思っても無理
- 単純な Collision システムを組み込んでいたが、他の物理エンジン使いたくなったときに無駄な存在になる
    - エンジンに対して、システム単位でも足し引きができるようにすると柔軟性が上がる
- Pooling しにくい
    - 後付けでちょっと仕組みを足したが、最初から考えておくべきだった
    - オブジェクト生まれては消えるゲーム作るときに new 減らすのはやっぱり必須

## ECS にすべきか

### Entity-Component System おさらい

- 通称 ECS
- ゲームのソフトウェア設計では昔からあるやり方のひとつ
    - 日本だとあまり聞かないけど英語でググるとたくさん出てくる
    - 書籍「ゲームエンジン・アーキテクチャ」では 15 章で言及されてる
- オブジェクト主体の見方に対して、データ（プロパティ）主体の見方
    - OOP に対して Data-Oriented な考え方
- 純粋なコンポーネントモデルまで行くと、ゲームの Entity は Component（ほぼ Value Object）
  のコンテナでしかない感じ
    - Entity を走査するのではなく、各 Component を扱う System 達が Component を走査する
    - 処理をオブジェクトではなく、システムに書く。横断的な視点
    - OOP におけるカプセル化は破壊することを受け入れる
- Unity は Component 指向だが純粋な ECS ではない

#### Pros

- メモリ効率を上げやすい（メモリ上で物理的に近くに並ぶデータ型を走査するので）
    - Component の部分を Pooling しやすい
- でかい継承構造（blob アンチパターン）を避けられる
- うまくやれば Component の組み合わせで柔軟な表現ができる

#### Cons

- うまくやらないといけない
    - 人間に分かりやすい OOP からのパラダイムシフトが要る
    - チームで導入するには 2015 年現在では抵抗ありそう（関数型と似てる）
- 個人的には、中規模以上のものを作る時に System のレイヤーが見通しよいままでいられるのかが懐疑的

### 参考リンク

#### 継承よりコンポジションという話

- [Composition over inheritance - Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/Composition_over_inheritance)
- [クラスの「継承」より「合成」がよい理由とは？ゲーム開発におけるコードのフレキシビリティと可読性の向上 | プログラミング | POSTD](http://postd.cc/why-composition-is-often-better-than-inheritance/)
- [Component · Decoupling Patterns · Game Programming Patterns](http://gameprogrammingpatterns.com/component.html)

#### ECS 関連

- [エンティティ・コンポーネント・システム - Wikipedia](https://ja.wikipedia.org/wiki/%E3%82%A8%E3%83%B3%E3%83%86%E3%82%A3%E3%83%86%E3%82%A3%E3%83%BB%E3%82%B3%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%8D%E3%83%B3%E3%83%88%E3%83%BB%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0)
- [階層構造を進化させる](http://qpp.bitbucket.org/translation/evolve_your_hierarchy/)
    - [Cowboy Programming » Evolve Your Hierarchy](http://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/)
- [What is an entity system framework for game development? | Richard Lord](http://www.richardlord.net/blog/what-is-an-entity-framework)
- [Why use an entity system framework for game development? | Richard Lord](http://www.richardlord.net/blog/why-use-an-entity-framework)
- [Avoiding the Blob Antipattern: A Pragmatic Approach to Entity Composition - Tuts+ Game Development Tutorial](http://gamedevelopment.tutsplus.com/tutorials/avoiding-the-blob-antipattern-a-pragmatic-approach-to-entity-composition--gamedev-1113)
    - [Create a Simple Asteroids Game Using Component-Based Entities - Tuts+ Game Development Tutorial](http://gamedevelopment.tutsplus.com/tutorials/create-a-simple-asteroids-game-using-component-based-entities--gamedev-1324)
- [データ指向設計 (または何故OOPで自爆してしまうのか) - 雑記帳](https://sites.google.com/site/shunichisnote/translations/data-oriented-design)
- [Entity/Component Game Design That Works: The Artemis Framework | Piemaster.net](http://piemaster.net/2011/07/entity-component-artemis/)
- [Games And Entity Systems | Shaun Smith](http://shaun.boyblack.co.za/blog/2012/08/04/games-and-entity-systems/)
- [ゲーム パフォーマンス: データ指向プログラミング - Google Developer Japan Blog](http://googledevjp.blogspot.jp/2015/08/blog-post.html)
- [Component basedgameenginedesign](http://www.slideshare.net/DADA246/component-basedgameenginedesign-23304862)
- [Entity Systems in game development | rokatainment](http://www.rokatainment.de/2014/08/16/entity-systems-in-game-development/)
- [Overview of Entity Component System (ECS) variations with pseudo-code](https://gist.github.com/LearnCocos2D/77f0ced228292676689f)
- [Entity Component System framework, redux | IceFall Games](https://mtnphil.wordpress.com/2013/03/23/entity-component-system-framework-redux/)

## 僕の方針

- 純粋なコンポーネントモデルにはしない
- 「空の Entity に Component アタッチする感」は出す
- 大衆向けのやり方として、Component に処理は書いちゃう（純粋な Value Object にはしない）
    - Actor に書いてたようなことは Script Component に書く（Unity のノリ）
- Component が Entity から別の Component 取得する、みたいなのは許す
    - Tween Component が Position Component 取得して状態書き換えるとか
- Component ごとの処理の順番はエンジンへの System 登録時に定義
    - ここはエンジンのユーザが干渉できるようにする
    - 究極、別のライブラリ使いたくなったらその System だけ差し変えられるように
- Component は Pooling したい（new 減らしたい）

### Unity でいいのでは

- 再開発は趣味プログラミングならではの贅沢
- あとはまあ勉強目的

### このご時勢に AS3 ですか

- 案外オープンソースのソフトウェア資産あるし
- Haxe + OpenFL とかちょっと考えたけど iOS / Android 真面目に考えるとまだ整ってない


