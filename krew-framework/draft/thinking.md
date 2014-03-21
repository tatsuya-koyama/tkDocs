---
title: '（krewFramework を作るときに考えたこと）'
date: '2013-12-03'
description:
categories: []
tags: [anything, krewFramework]
position: 9902
---

# krewFramework を作るときに考えたこと

## 関連メモ

- [ゲーム実装するときに考えることリスト](/dev-log/thinking-game-engine-todo/)
- [ゲーム開発のツールについて考える](/dev-log/thinking-game-dev-tool/)
- [ゲームのチーム開発の開発フローについて考える](/dev-log/thinking-game-team-dev-flow/)
- [プログラミングについて考える](/dev-log/thinking-programming/)
- [Adobe AIR ゲーム開発メモ](/dev-log/adobe-air-dev-note/)
- [Flash Builder での開発メモ](/dev-log/flash-builder-dev-note/)

## krewFramework って何

クルー・フレームワークと読みます。

- [俺](http://www.tatsuya-koyama.com/4.0/html/tkinfo/profile.html)
  による俺のための俺俺ゲームフレームワーク
- ゲームつくるときまあ大体みんなこういうことやるよね、といった処理のフレームワークを
  Adobe AIR + Starling というアーキテクチャの上にのっけたもの
- 似たソリューションはあるけど、自分の勉強のために自作して、自分で使う
    - 公開する前提で作ることで品質を高める

### 類似のソリューション

- [Cytrus game engine](http://citrusengine.com/)
    - 同じレイヤーで、たぶん一番有名
    - Starling と Away3D と各種 Physics を包括的に扱う感じで、
      やりたいこと先にやられてる感あるけど参考にしつつ自分は自分のスタイルで組む

___

- [Ash entity framework](http://www.ashframework.org/)
    - サイトがシンプルでオシャレ
    - リンクから飛べるブログ記事もしっかり書かれていて参考になりそう


### ToDo

- [ToDo] 安定してきたら swc で提供する
- [ToDO] テストをもっと書く

## 名前について

- 名前は大事
    - 命名センスもプログラマに求められる能力のひとつ
- krew は英単語の crew から：

>【名】  
>  
>    1. 〔船のすべての〕乗組員、クルー
>    1. 〔船のすべての〕下級船員◆船長、航海士、士官などを除く乗組員。
>    1. 〔飛行機や宇宙船のすべての〕搭乗員、クルー
>    1. 〔一緒に仕事をする〕組、班、グループ
>    1. 〈話〉〔一緒に過ごす〕仲間、一団
>    1. 〔競漕艇の〕クルー
>    1. 〔競技の〕競漕

- 映画の撮影クルーとか、仕事の構成メンバーとか、そういう意味合いからチョイス。

もともと僕は、ビデオゲームを動かす各モジュールは、映像作品や演劇の舞台を作るメンバーになぞらえると
うまくハマるのではないかと考えていた。（昔演劇やってたのも影響してる）

- 役者（Actor 指向における Actor そのもの）
    - 舞台（シーン, ゲーム画面）
    - 舞台の上に Actor を上げる
- カメラマンが舞台の View を切り取る
- あと照明さんとか、音響さんとか
- 全体の流れを指揮するディレクターがいる

___

実際には、プレイヤーからの干渉がある部分や、人と物（Agent と Object）みたいにしなくても
十分すっきり実現できることから、あんまり映像・演劇の構成員に沿った形にはならなかったが、
響きもよいのでこの名前を残した。

crew の c を k に変えて krew にしたのは以下の理由からだ：

> - crew はタイプしにくい。krew は結構タイプしやすい
> - 検索性が上がる。"krew Framework" でググってもそれらしいものはない


## フレームワークをなぜ自分で作るのか

- 勉強のためというのが一番大きい
    - 実績のある既存のライブラリや、車輪の再発明を避けるというのは仕事の進め方としては正しい
    - だが修行の身においては自分の手で作ってみるというのが一番身に付く

___

- 言語は問題ではない
    - 今回は ActionScript, Starling とその周辺のライブラリ群を使うが、
      コアコンセプトは言語・プラットフォーム非依存のものだ
    - フレームワークを自分で構築する中でこの辺の概念を頭の中にまとめられれば、
      他の環境に移ったときでもソリューションを作るのが楽になる

___

- その他
    - 自分のソフトウェア資産を作る
    - 他人にゲーム開発を教える時のサンプルにもなる
    - 市場に対して自分のプログラマとしての価値を明示する



## フレームワークがすべきこと

- やり方を制限・規定する
    - 実装スタイルが統一できる
    - 多人数開発で実装の把握がしやすくなる
- 規定した分だけ、楽に・安全にする


## この手のやつを手堅く作るには

- 融通が効くようにしておく
    - 足し引きの「引き」がしやすいのが肝心
    - コアの哲学はシンプルに、後はコンポーネント増やしていくような感じ
        - 使ってもいいし使わなくてもいい
    - いざとなればカスタムできるようにしておくとベター
        - 差し替えられるインタフェース用意しておくとか
    - 何か他のライブラリ利用するときも、選べる（差し替えられる）ようになってるとか

___

- 割としっかりしたゲームを実際に作って一緒に公開しておく
    - 結局サンプルコードが一番とっつきやすい
    - ある程度ちゃんと作ってあると説得力出るし使ってもいい感じが増す


## ソフトウェア設計の手法、方法論

- Actor 指向
    - オブジェクト指向でイベント駆動
- 依存性の注入（Dependency Injection）
- Component 指向、プラガブル
- 設定より規約（[Convention over Configuration](http://en.wikipedia.org/wiki/Convention_over_configuration)）
- [Composition over Inheritance](http://en.wikipedia.org/wiki/Composition_over_inheritance)
- [Single responsibility principle](http://en.wikipedia.org/wiki/Single_responsibility_principle)
- DRY 原則
- レイヤーに分けてレイヤー間はインタフェースでやりとり
    - 他のレイヤーの実装は気にしないでよいように

___

- [ソフトウェア原則](http://objectclub.jp/technicaldoc/object-orientation/principle/)
- [UNIX哲学](http://ja.wikipedia.org/wiki/UNIX%E5%93%B2%E5%AD%A6)


## クラス名の命名とパッケージ分け

- 先頭に Krew という定型子をつけるか問題
    - パッケージ名あるけど、Sprite や Vector みたいなかぶりやすい名前は案外ぶつかった時に面倒
    - 全部につけるのもうっとおしい
        - リファレンスのインデックスとかひとつになっちゃうしさ

### 方針

- 利用者が直接さわるクラスって全部じゃない
    - 直接さわるやつは core/, 気にしなくてもいいやつは core_internal/ に分ける
    - さわるやつには Krew をつけておこう
    - Vector とか ResourceManager みたいな一般的な名前にも一応つけておこう

### パッケージ構成

    krew-framework/
    └── krewfw/
        ├── KrewConfig.as
        ├── NativeStageAccessor.as
        │
        ├── builtin_actor/
        │   ├── display/
        │   ├── event/
        │   ├── system/
        │   └── ui/
        │
        ├── core/
        │   ├── KrewActor.as
        │   ├── KrewBlendMode.as
        │   ├── KrewGameDirector.as
        │   ├── KrewGameObject.as
        │   ├── KrewScene.as
        │   └── KrewSystemEventType.as
        │
        ├── core_internal/
        ├── data_structure/
        └── utils/
            ├── krew.as
            ├── as3/
            ├── dev_tool/
            ├── starling/
            └── swiss_knife/


- core_internal は直接触れることない
    - 大体は KrewActor および KrewGameObject のインタフェースを通して制御する


### クラス名のつけかた関連

- Resource と Asset の違いとは
    - Resource は流動的な資源、Asset は静的な資産ってイメージがある
    - とりあえず ResourceManager （メモリうんぬん）に Assets （画像ファイルとか）を指定する、
      って感じでよいかな


## Design Philosophy

- 一般的な Actor 指向
- どうせやることはわざわざ書かせない
- 多数派をデフォルトの挙動にする

___

- krewFramework を使う人は、Starling の実装・インタフェースを気にしなくてよいようにする
    - レイヤー間の依存性の排除をちゃんとやる
    - 他のプラットフォームに移植する時に、インタフェースをそのまま持っていける
    - 具体的に言うと、krewFramework を使う人が特別なハック以外で
      Starling や Away3D のクラスの import を行わなくて済むようにする

## コンセプト

- ゲームの各場面の単位を Scene と呼ぶ
- Scene に、その場面の初期状態で必要な Actor を投げ込む
- あとは Actor 達の update を呼ぶだけ
- Scene が終わるイベントが投げられたら、GameDirector が次の Scene に切り替える

### 表示の前後関係の制御

- レイヤーで管理
    - Scene 作る時にそのシーンに必要なレイヤーを定義
    - Actor は指定したレイヤーにセットする
    - レイヤー間をまたぐような Actor は今のところ想定していない
    - レイヤー単位で時間の流れの速さを変えたりできる

### 今回のフレームワークにおける Scene とは

- 基本的に **「アセットをメモリに保持しておくスコープ」** とする
- つまり「シーン遷移」 = 「ゲーム画面で Loading が走ってよいタイミング」
- 動的にリソースを load / purge したくなった時のことはまだ考えてない

### ウインドウみたいな UI をどう制御するんだ問題

- もうちょっと整備してもよいかも。考え中
- 前述の通り、シーンはリソースのスコープなので、シーン = ウインドウみたいにして
  スタックのように扱うことはやらない

___

- とりあえずはウインドウの Actor を作って頑張れ
- レイヤー単位で時を止めたりタッチ不能にしたりできるようになってる
- Mr.WARP と iro-mono のメニューはそれで実現してる

### Actor 指向とは（既存の概念の復習）

- 協調型マルチタスキングの手法として昔からゲームに使われているモデル
    - 1973 年に発表された並行計算の数学的モデルの一種
- 日本ではよく **タスクシステム** という言葉が使われてきた
    - 本質的には同じものである

___

- アクターモデルの哲学は、**すべてのものはアクターである** ということ
    - オブジェクト指向も全てオブジェクトだしメッセージパッシングもするけど、基本的には逐次実行
    - アクターは本質的に並列性を備えている
- Actor はコーディング上ではそのまま Actor とも書かれるし、
   GameEntity や GameObject, Process という名前が使われることもある。
   （日本だとタスクシステムという言葉がよく使われた関係で Task も使われる）

___

- アクターの性質
    - (1) 他のアクターに有限個のメッセージを送る
    - (2) 有限個の新たなアクターを生成する
    - (3) 次に受信するメッセージに対する動作を指定する
- アクターが他のアクターと通信するにはアクターのアドレスを知る必要がある
    - アクターの通信手段
        - (a) 受信したメッセージにアドレスが書いてある
        - (b) そのアクターは何らかの方法ですでに相手のアドレスを知っている
        - (c) そのアクターは自分が生成したアクターである

___

- 実際には、アクターが直接他のアクターを指定するよりも、
   Notification Service を１つ介してメッセージをやりとりし、
   アクター同士を疎結合にした方がスケールする。
    - こうした手法は **Publish / Subscribe メッセージングモデル** と呼ばれる
        - メッセージを送る側は、それを受け取る Actor のことは気にしない
        - そのメッセージに関心のある Actor は事前にメッセージを受け取りたい旨を登録しておく


### 大まかな使い方のイメージ

- KrewGameDirector 継承したクラス作って最初の Scene を start させる
- 各シーンは KrewScene を継承
    - お決まりの処理はハンドラの中身を書く感じでやる
    - init で必要な Actor 達を setUpActor() する




## 内部的な処理の流れ

### Scene の初期化フロー



### フレームのアップデート処理

Flash のイベントはオーバヘッドありそうってのもあって、
ENTER_FRAME イベントには Scene だけが毎フレーム 1 回呼応している。
Scene が各 Actor 達の update を呼ぶ感じ

- Scene は毎フレーム LayerManager の update を呼ぶ
- LayerManager は各 Layer の update を呼ぶ
    - Layer は Actor を継承している
- Actor は update で、自分が持つ Actor 達と自分自身の onUpdate を呼ぶ

> レイヤーごとに時間の流れの早さを変えられるようにするため、  
> starling.animation.Juggler は各 Layer が 1 つずつ持っている


## 非同期処理

- いわゆる JSDeferred 的なやつ
- タスクを連続して実行させるのはまあ簡単
- 重要なのは、パラレルなタスクと全体のエラー処理が書けるか
- JS のライトウェイトに書ける感じはよい
    - でも個々のタスクを「オブジェクトにもできる」ってのは価値がある
    - JS のようにオブジェクトとかメソッドチェーンで楽にも書けるし、
      型のある AS ならではの感じでクラス化して使い回しもできる、ってのがいいなぁ

- 参考リンク
    - [（V8で）Promiseが実装された](http://js-next.hatenablog.com/entry/2013/11/28/093230)
    - [GitHub | ASDeferred](https://github.com/minodisk/asdeferred)
    - [Promises Promises (AS3 blog)](http://blog.onebyonedesign.com/actionscript/promises-promises/)
    - [GitHub | caolan / async](https://github.com/caolan/async)


### 何がしたい

例えばこういうのある

- 画像データをサーバからダウンロード（非同期）
- クライアントに保存（非同期）
- それを読み込んでメモリに展開（非同期）
- 描画処理

___

- まあ Deferred な話なんだけど
    - 場合によっては並列にしたいタスクもあるよね
    - 前のタスクで得た情報を使いたくなるよね
    - 途中でエラーになったら catch したいよね

## Scene のあり方再考

- 基本的な思想は「必要なリソースの列挙」と「最初に必要な Actor の列挙」
- Scene であれこれ書きたくないのは、「Actor を外す・差し替える」のを楽にしたいから
    - setUpActor の並びは粒度が対等に並んでいるべき
- リソースの準備はできるだけ終えてから Actor を始動させたい
    - StateMachine で初期化処理色々やってから真の初期化、みたいにも書けるけど
      Scene の時点で見通しが分からないので望ましくない
    - Scene ではほぼリソース記述されてなくて、実は Actor が色々読み込んでるってのも気持ち悪い
    - でも今の配列 1 回返すだけのやり方じゃ不十分
    - 読み込むファイルの内容が json ファイルに書かれていて、まずそれを読み込みたいとかざらにある
- 突き詰めると、やはり Scene に「初期化コマンド一覧」みたいなのが必要なんじゃないか？
    - ここを Deferred っぽく書けたら完璧かも

___

- リソース読み込みを複数段階分けると、「連続して使うリソースは再読み込みしない」
  みたいなバックエンドを作るのが大変なんだよなぁ

## Actor じゃなくても Actor の便利機能使いたい話

- 気持ちは分かる
    - メッセージングとかしたいけど View とかいらないんだよ的なやつとかね
    - static なクラスでよくてわざわざ Scene にのせたり面倒なんだよ的なやつとかね
- Actor と Scene に乗っていないやつでも、思想的に呼んでもいいものとそうではないものがある
- Scene 上で生存期間を持つ Actor だからこそ許されていること（タスクの登録系とか）は外の世界で使えてはならない

___

- いちいち Actor にして Scene にのせてオーバヘッド上げたくない、
  static な Model とかが AssetManager にアクセスしたいけど方法がないから
  仕方なく参照渡す、みたいになっちゃってるのが実情
    - つまりポリシーを守りながら要件を満たすだけの機能を提供できてないってことだ

___

- 今 GameObject が public でできること

        // accessor
        get id():int {
        get sharedObj():KrewSharedObjects {
        get krew():KrewTopUtil {
        
        // framework から呼ばれる
        set sharedObj(sharedObj:KrewSharedObjects):void {
        init():void {
        onUpdate(passedTime:Number):void {

        // リソースアクセス系
        getTexture(fileName:String):Texture { 
        getImage  (fileName:String):Image   { 
        getSound  (fileName:String):Sound   { 
        getXml    (fileName:String):XML     { 
        getObject (fileName:String):Object  { 
        loadResources(fileNameList:Array, onLoadProgress:Function,
        
        // 音の操作
        playBgm(bgmId:String, vol:Number=NaN, startTime:Number=0):void {
        pauseBgm():void {
        resumeBgm():void {
        stopBgm():void {
        playSe(seId:String, pan:Number=0, loops:int=0,
        stopSe():void {
        stopAllSound():void {
        
        // レイヤー操作
        getLayer(layerName:String):StageLayer {
        setTimeScale(layerName:String, timeScale:Number):void {
        resetTimeScale(layerName:String):void {
        setLayerEnabled(layerNameList:Array, enabled:Boolean):void {
        setLayerEnabledOtherThan(excludeLayerNameList:Array, enabled:Boolean):void {
        setAllLayersEnabled(enabled:Boolean):void {
        
        // コリジョン
        setCollision(groupName:String, shape:CollisionShape):void {
        
        // フェード
        blackIn (duration:Number=0.33, startAlpha:Number=1):void { 
        blackOut(duration:Number=0.33, startAlpha:Number=0):void { 
        whiteIn (duration:Number=0.33, startAlpha:Number=1):void { 
        whiteOut(duration:Number=0.33, startAlpha:Number=0):void { 
        colorIn (color:uint, duration:Number=0.33, startAlpha:Number=1):void { 
        colorOut(color:uint, duration:Number=0.33, startAlpha:Number=0):void { 
        
        // メッセージング。これは呼べていい
        sendMessage(eventType:String, eventArgs:Object=null):void {

        // 登録する系は呼ぶべきでない        
        listen(eventType:String, callback:Function):void {
        stopListening(eventType:String):void {
        stopAllListening():void {


- 今 Actor が public でできること

        // accessor
        get cachedWidth():Number {
        get cachedHeight():Number {
        get color():uint {
        set color(color:uint):void {
        get childActors():Vector.<KrewActor> {
        get numActor():int {
        get isDead():Boolean {
        get hasInitialized():Boolean {
        set hasInitialized(value:Boolean):void {
        
        // framework から呼ばれる
        setUp(sharedObj:KrewSharedObjects, applyForNewActor:Function,

        // Actor の状態を変えたりするもの。外の者が呼ぶべきでない
        addInitializer(initFunc:Function):void {
        addImage(image:Image,
        changeImage(image:Image, imageName:String):void {
        addText(text:TextField, x:Number=NaN, y:Number=NaN):void {
        addActor(actor:KrewActor, putOnDisplayList:Boolean=true):void {
        passAway():void {
        setVertexColor(color1:int=0, color2:int=0,
        addTouchMarginNode(touchWidth:Number=0, touchHeight:Number=0):void {
        sortDisplayOrder():void {
        addTween(tween:Tween):void {
        removeTweens():void {
        enchant(duration:Number, transition:String=Transitions.LINEAR):Tween {

        // 使いたくなるが呼ぶべきでない
        act(action:StuntAction=null):StuntAction {
        react():void {

        // Actor に登録する系だが使いたくなる
        addScheduledTask(timeout:Number, task:Function):void {
        delayed(timeout:Number, task:Function):void {
        addPeriodicTask(interval:Number, task:Function, times:int=-1):void {
        cyclic(interval:Number, task:Function, times:int=-1):void {
        delayedFrame(task:Function, waitFrames:int=1):void {
        cyclicFrame(task:Function, waitFrames:int=1, times:int=-1):void {

        // これは呼べていい
        createActor(newActor:KrewActor, layerName:String=null):void {

### 「Actor なら呼んでいいもの」のポリシー

- ポリシーを決め、やってはいけないことはやれないような形を保つことが、
  フレームワークの責務だ

#### OK

- 一方向にただ投げるようなものは呼べても害は無い
    - 恐らく Scene 専属のシステム Actor に処理を委譲する形になるのだろう
- 例えば以下はよいだろう
    - sendMesasge
    - createActor

___

- sharedObject を通してやっていることも、生存していることが保証されている Actor を通して
  さらに委譲することについては、やっていることの本質的な違いは無い
    - getImage, getObject, ...
    - loadResources
    - playBgm, ...
    - getLayer, setTimeScale, ...
    - blackIn, blackOut, ...
- まあ sharedObject は一応「Scene 上の Actor 達にだけ」使ってほしいから
  インスタンスを引き渡す形にしてるんだけどね…

#### NG

- Actor にタスクを登録させるものは、「その Actor が死んだら解放されることを担保する」という意味で
  他人がやるべきではない
- Actor に登録してよいタスクは、その Actor に関するもの（自分自身のメソッド）だけである
- **要は「登録された側だけが生きている」状態が発生してしまってはいけない**
    - Other が Other.handler を Actor.delayed で呼んだりしてはいけない。
      もしコールされるまでの間に Other が disposed な状態になってしまったら、
      Actor は無効なオブジェクトのメソッドを呼んでしまうことになる。

___

- だから、以下のようなものは呼んではいけない
- （呼びたいのならばそいつは Actor として生きなければならない）
    - act
    - delayed, cyclic
    - listen

#### 悩みどころ

- フレームワークの他のコンポーネントが呼ぶために public にしちゃってるメソッドが結構ある。
- こうなっていると、その気になれば Actor の参照を渡して Scene 上にいないクラスが好き勝手できちゃう




<br/><br/><br/>


