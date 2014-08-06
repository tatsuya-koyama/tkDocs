---
title: 'コンセプト | Actor 指向'
date: '2014-03-02'
description:
categories: []
tags: [anything, krewFramework, Philosophy]
position: 1002
---

# フレームワーク設計のコンセプト

## ゲームの構成要素 - Scene と Actor

ゲームの実装方法に完璧な解はありませんが、多く採用される一般的な設計指針というものは存在します。
ポピュラーなのはタイトル画面、ゲーム画面、リザルト画面など画面遷移が行われるような単位を
**シーン** に区切り、シーン上に **ゲームの構成要素** を並べて協調動作させるというやり方です。

krewFramework もこの設計指針に従っています。
krewFramework では、ここで言うシーンをそのまま **Scene**, ゲームの構成要素を **Actor** と呼びます。
Actor は「ゲームのキャラクター１体」を例にとればイメージしやすいと思いますが、
スコア表示などの UI コンポーネントや、「時間を管理する」などの **目に見えない処理の単位** なども
Actor になりえます。

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/krewfw/actors.png"
       style="width: 100%; max-width: 865px; margin-bottom: 2.5em;" />
</div>

Scene は最も一般的な呼び名だと思われますが、Screen や Stage などと呼ぶ人もいるでしょう。
Actor に当たるものは文化によって呼び方が様々です。
GameObject や Entity, Process などを実際に目にしたことがあります。
日本のゲーム開発黎明期にはもう少しプリミティブな「タスクシステム」と呼ばれるものが知られていたため、
Task という名称を使う人もいると思います。


## Actor 指向

krewFramework は **Actor指向** のフレームワークです。
[Actor モデル](http://ja.wikipedia.org/wiki/%E3%82%A2%E3%82%AF%E3%82%BF%E3%83%BC%E3%83%A2%E3%83%87%E3%83%AB)
（[Actor model](http://en.wikipedia.org/wiki/Actor_model)）
に基づいてゲームの構成要素を協調動作させます。

Actor モデルの哲学は、**すべてのものは Actor である** ということです。
krewFramework でゲームを書くことは、基本的に Actor を実装していくことになります。
Actor モデルにおける **Actor の性質** は次のようなものです。

> - (1) 他の Actor にメッセージを送ることができる
> - (2) 新しい Actor を生成することができる
> - (3) 受信したメッセージに対する動作を指定できる

これをベースに、krewFramework では Actor の性質を、ゲーム向けに以下のように定義し直しました。

##### krewFramework における Actor の定義

> - (1) Scene 上にいる Actor だけが、Actor として振る舞える
> - (2) Actor は不特定多数の他の Actor にメッセージを投げられる
> - (3) Actor は他の Actor からのメッセージを listen できる
> - (4) Actor は新しい Actor を Scene 上に生み出せる
> - (5) Actor は自滅できる（自分で Scene 上から居なくなれる）


### いわゆるイベントドリブン？

賢明な方によっては、いわゆる **「イベントドリブンのオブジェクト指向プログラミング」**
と同じではないかと思われるかもしれませんが、
実質的にそう考えてもらって差し支えありません。
ここで言う「オブジェクト」の性質を明確に定義してシステム上で一貫させるために、
Actor という言葉を使っています。


### Actor の性質の実装イメージ

Actor の性質を実際のコードで表すと、以下のようなイメージになります。

___
##### (1) Scene 上にいる Actor だけが、Actor として振る舞える

そのため、Scene 開始時に必要な Actor をセットするという実装を Scene クラスで行う必要があります。

    import krewfw.core.KrewScene;
    ...

    public class YourTitleScene extends KrewScene {

        public override function initAfterLoad():void {
            /**
             * Scene クラスでは、最初にいるべき Actor を
             * Scene 上に並べるということだけをします。
             * Scene にはゲームロジックを書くことはしません。
             */
            setUpActor('ui-layer', new TitleLogoActor());
            setUpActor('ui-layer', new StartButtonActor());
        }
        ...

___
##### (2) Actor は不特定多数の他の Actor にメッセージを投げられる
##### (3) Actor は他の Actor からのメッセージを listen できる

KrewActor を継承したクラスの中で以下のように書きます。

    import krewfw.core.KrewActor;

    public class YourActor extends KrewActor {

        public override function init():void {
            // メッセージのリスナー登録
            listen("Event_from_others", _myCallbackFunction);
        }

        public function someFunc():void {
            // 他の Actor 達にメッセージを送る
            sendMessage("Event_from_me");
        }
        ...


___
##### (4) Actor は新しい Actor を Scene 上に生み出せる

KrewActor を継承したクラスの中で以下のように書きます。

    import krewfw.core.KrewActor;

    public class MyShipActor extends KrewActor {

        public function fire():void {
            // 新しい Actor を Scene 上に生み出す
            createActor(new BulletActor(x, y));
        }
        ...

___
##### (5) Actor は自滅できる（自分で Scene 上から居なくなれる）

KrewActor を継承したクラスの中で以下のように書きます。

    import krewfw.core.KrewActor;

    public class BulletActor extends KrewActor {

        public function onOutOfField():void {
            // 自滅して Scene 上から居なくなる
            passAway();
        }
        ...



## Actor のリソース管理

Actor の生存期間は Scene のスコープに閉じています。
Actor が何をしている最中でも、**Scene 遷移時には Scene 上の全ての Actor が破棄されます。**
Actor のリスナー登録や、Actor に登録されていたタスクなどは
krewFramework が責任を持って解放します。

krewFramework の利用者は krewFramework のインタフェースを通じて Actor を生成・破棄する限り、
自分で解放処理などを書く必要がなく、メモリリークを気にする必要がありません。

> グローバルのレイヤーを作りそこに Actor を置くことで、
> Scene をまたいでも破棄されないグローバルな Actor を作ることもできます。


## Scene の考え方

krewFramework では、Scene をリソースのスコープとしています。
言い換えれば、**「遷移時に Loading が挟まってもよい画面の単位」** が Scene となります。

「その Scene に必要なリソース」（画像や音などのアセット）は Scene 冒頭でメモリに読み込まれ、
Scene の最中はメモリに保持され続けます。
そして Scene 遷移時に解放されます。

Scene で使う Actor の実装は **「自分に必要なリソースはすでに読み込まれている」前提** で行います。
リソース名に依存せず汎用的に使えるような Actor を書く場合には
リソース名をコンストラクタの引数で渡してやることもできますが、
手間が増えるので実装の中に埋め込んでしまってもよいでしょう。
Actor はゲーム固有のスクリプトのような存在だと見なし、
ある程度は書き捨てになってもよいというスタンスです。



<br/>

