---
title: 'krewFramework を作るときに考えたこと'
date: '2013-12-03'
description:
categories: []
tags: [anything, krewFramework]
position: 4
---

# krewFramework を作るときに考えたこと

## krewFramework って何

クルー・フレームワークと読みます。

ドキュメントは[こちら](/krew-framework/top)。

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

### ToDo

- [ToDo] 安定してきたらリポジトリを公開する
- [ToDO] テストをちゃんと書く

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

- crew はタイプしにくい。krew は結構タイプしやすい
- 検索性が上がる。"krew Framework" でググってもそれらしいものはない


## フレームワークがすべきこと

- やり方を制限・規定する
    - 実装スタイルが統一できる
    - 多人数開発で実装の把握がしやすくなる
- 規定した分だけ、楽に・安全にする


## 設計の手法、方法論

- Actor 指向
    - オブジェクト指向でイベント駆動
- 依存性の注入（Dependency Injection）
- Component 指向、プラガブル
- 設定より規約（Convention over Configuration）
- DRY 原則
- レイヤーに分けてレイヤー間はインタフェースでやりとり
    - 他のレイヤーの実装は気にしないでよいように


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

### パッケージ

    krewfw/
    ├── KrewConfig.as
    ├── NativeStageAccessor.as
    ├── builtin_actor
    │   ├── ColorActor.as
    │   ├── ColorRect.as
    │   ├── DraggableActor.as
    │   ├── KrewMovieClip.as
    │   ├── KrewStateHook.as
    │   ├── KrewStateMachine.as
    │   ├── ScreenCurtain.as
    │   ├── ScreenFader.as
    │   ├── SimpleButton.as
    │   ├── SimpleImageActor.as
    │   ├── TextButton.as
    │   └── TouchFilter.as
    ├── core
    │   ├── KrewActor.as
    │   ├── KrewBlendMode.as
    │   ├── KrewGameDirector.as
    │   ├── KrewGameObject.as
    │   ├── KrewScene.as
    │   └── KrewSystemEventType.as
    ├── core_internal
    │   ├── CollisionGroup.as
    │   ├── CollisionSystem.as
    │   ├── IdGenerator.as
    │   ├── KrewResourceManager.as
    │   ├── KrewSharedObjects.as
    │   ├── NotificationPublisher.as
    │   ├── NotificationService.as
    │   ├── ProfileData.as
    │   ├── SceneServantActor.as
    │   ├── StageLayer.as
    │   ├── StageLayerManager.as
    │   ├── StuntAction.as
    │   ├── StuntActionInstructor.as
    │   └── collision
    │       ├── CollisionShape.as
    │       ├── CollisionShapeAABB.as
    │       ├── CollisionShapeOBB.as
    │       ├── CollisionShapeSphere.as
    │       └── HitTest.as
    ├── starling_utility
    │   └── TextFactory.as
    └── utility
        ├── KrewLine2D.as
        ├── KrewPoint2D.as
        ├── KrewSoundPlayer.as
        ├── KrewTimeKeeper.as
        ├── KrewTimeKeeperTask.as
        ├── KrewUtil.as
        └── KrewVector2D.as

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



## 作業メモ

### こまかい設計上の悩みポイント

- Actor の init に引数渡したくなる感
    - 今だとコンストラクタで渡してメンバに保持しておいて init 内で使うとかなってて微妙

___

- Actor の中で getImage('hoge') って書くのはまあいいとして、
  getGlobalImage('fuga') とかの使い分け要るのは微妙？
    - Actor 書く側が使われる側でのリソース指定を気にしとかなきゃいけないところが微妙
    - 処理のオーバヘッドは増えるが「シーンスコープから探して、無ければグローバルスコープから探す」とするか

___

- Scene も Actor でよかったんじゃないか説
    - たぶん最初は色々悩んでて GameObject から Scene と Actor に分岐させてしまった
    - 「Scene は Actor を束ねるもの」だけど、別に Scene が Actor でもよいよな
    - Layer も Actor のサブクラスになったしな
    - Actor が Actor を持てればいいって話。Composit パターン
    - 結局メッセージングとかシステム側でやるときに Scene に持たせたシステム Actor に
      仕事させたりしちゃってる。Scene 自体が Actor だったらもっとすっきり書けた気がする
    - あーでも update が無限ループするみたいな事故もありそう。わからん。

___

- グローバルとシーンスコープの 2 つだけだとちょっとやりづらい？
    - ちょっとした画面遷移でいちいちファイルアクセスすると割と実機での Loading 気になる
    - アセット多いゲームパートと、それ以外のパート、みたいにシーンのグループで
      読み込んでおくグループコントロールしたくなってくる

### こまかい実装上の悩みポイント

- Asset 読み込みの効率化
    - シーン遷移で全部 purge じゃなくて、差分だけ purge & load したいところだ
    - でも starling.utils.AssetManager 使ってるとやりにくいな
    - まあよく使うものは Global に読み込んでもらえって話か
- ただシーン遷移のフェードアウトしながら次のシーンの読み込むとかできたらカッコいいよな
    - まあそれ頑張るとフェードアウトが結構カクついちゃうかもしれんが…

### 大きめ ToDo

- ゲームのオブジェクトはワールド座標内に置くようにして
  レイヤーごとに Camera が切り取るみたいな感じにする

### こまかい ToDo

- 描画要素を持たないやつ、setUpActor の引数で false 渡してるけど
  Actor 側にプロパティに false 入れる処理書いた方がいいんじゃね
    - touchable と同じ扱い

<br/><br/><br/><br/><br/><br/><br/><br/>

