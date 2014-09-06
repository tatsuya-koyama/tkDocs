---
title: 'Adobe AIR で開発したまとめ (2014 年 9 月)'
date: '2014-09-05'
description:
categories: []
tags: [anything, Game-Development, Adobe-AIR]
position: 110.4
---

# Adobe AIR でゲーム開発したまとめ<br/>（2014 年 9 月版）

## やったこと

<div style="float: right;">
  <img class="normal" src="{{urls.media}}/krewfw/adobe_air_logo.jpg" />
</div>

- スマフォアプリのゲーム開発、商用リリース
    - iOS, Android
    - Game Server あり
    - 課金あり
    - フレンド要素あり（ほんわか系）
    - 外部サービスとの連携あり
    - 動的アセットダウンロードあり

### 規模感とチーム構成

- 人月はざっくり 10 人強 x 8 ヶ月くらいかな
- （+ 音とデザインのアウトソースはあり）

{{# table }}
  -
    - 役職
    - 大体の人数
  -
    - Producer
    - 1
  -
    - Project Manager / Level Designer
    - 1
  -
    - Client Programmer
    - 2+
  -
    - Server Engineer
    - 2+
  -
    - Art Director
    - 1
  -
    - Artist
    - 2+
  -
    - Technical Artist
    - 1
  -
    - Assistant
    - 1+
{{/ table }}

> - 開発の規模感の参考までに。
> - 最初は少なくて途中で増やしていった感じ
> - 明るくほっこりした職場です

- わたし → 主に Client サイドの Lead Programmer

## 最初に所感

- 世間では「Flash は死んだ」「AIR って遅くてゲームには使えない」な印象がありそうですが
    - **Adobe AIR は死んでいない**
    - Flash はツールとして使い道がある
    - Stage3D がモバイルで使えるようになってからは AIR でも速い

___

- マルチプラットフォーム向けゲーム開発のソリューションとして、Adobe AIR はアリ
- スマフォ向け 2D ゲーム作るなら、Cocos などと並ぶ選択肢のひとつとして十分
    - Cocos とどちらを選ぶかは好みの問題（言語、周辺ツール、サポート観点）
    - 3D も頑張ればできるけどそこは Unity でいい気がする

## Adobe AIR とは

- もともとは各種 OS 向けにアプリケーションを作れるようにするためのランタイムライブラリ
- まあ Java の VM みたいなもの
- 最初は Web や Flash の技術で開発できるよ、みたいなノリでちょっとリッチなツール作りなどが主な用途だった
- Web の発展と時代の変化に伴い、2012 年くらいからはゲーム向けの技術として Adobe は注力してる感じ

### Flash のつらい歴史

{{# table }}
  -
    - 時期
    - 事案
  -
    - 2008 年 3 月
    - ジョブズ「iPhone で Flash サポートしないよ」
  -
    - 2010 年 1 月
    - Adobe は Flash/AIR のコードを iOS 向けにエクスポートする Packager for iPhone を発表
  -
    - 2010 年 4 月
    - Apple が iPhone SDK の規約を変更。「Obj-C, C, C++, WebKit の JS 以外しか使っちゃダメ」
      <ul>
        <li>Adobe めっちゃ怒る</li>
        <li>さらにジョブズ自ら "Thoughts on Flash" という文書で Flash を批判</li>
      </ul>
  -
    - 　　〜
    - Adobe は一度 Android に歩み寄ったが、Google も世間も HTML5 を選択するムードに
  -
    - 2011 年 11 月
    - Adobe もモバイル向けの Flash Player を諦める。HTML5 と AIR に注力するとする
  -
    - 2013 年 4 月
    - Unity が Flash のサポート廃止を発表
{{/ table }}

- こうしたニュースが取り上げられ、「Flash が死んだ」というイメージが世に広まる

### AIR と Stage3D の歴史

{{# table }}
  -
    - 時期
    - 事案
  -
    - 2011 年 10 月
    - Flash Player 11 で Stage3D が導入される。ここで初めてまともな GPU レンダリングが可能に
  -
    - 2012 年 3 月
    - AIR SDK 3.2 にて <b>モバイル版 AIR での Stage3D がサポート</b> される
  -
    - 2014 年 1 月
    - 2〜3 ヶ月スパンでアップデートが重ねられ、AIR SDK は 4.0 に
  -
    - 2014 年 4 月
    - Flash Player とバージョンを一致させるため、ここで AIR SDK 13.0 となる
  -
    - 2014 年 6 月
    - AIR SDK 14.0
{{/ table }}

- AIR SDK のアップデートはそれなりの頻度で行われている

## Stage3D

- 昔の Flash は描画を CPU で頑張ってた
    - 今でも旧来の方法で Flash の Display List を表示すると、ソフトウェアレンダリングになる
    - Stage3D は GPU レンダリングで 2D/3D を描画（内部で OpenGL とかを叩いてる）
    - Stage3D の描画レイヤーと、Flash の従来の Display List の描画レイヤーは分かれている
      （Display List が前面に来る）

> よくある勘違いに **「AIR って普通に Flash 再生できるんだよね」** というのがあるが、
> 普通にやるとソフトウェアレンダリングになるので遅い。
> GPU でやるためには、Flash で作ったものをデータに吐き出してそれを Stage3D のライブラリで読み込んで再生する、
> という（他のソリューションでも結局やるような）手順が必要になる

___

- 今回作ったゲームのアーキテクチャのレイヤー書くとこんな感じ

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/krewfw/krewfw_architecture.png"
       style="width: 100%; max-width: 893px;" />
</div>

- Stage3D は OpenGL / DirectX などのグラフィック API の上に乗る抽象化レイヤー

### AGAL

- Stage3D 用のシェーダ言語は **AGAL** という独自のもの
- GLSL, HLSL, Cg みたいな最近のやつと比べてずっと **低級** な文法
    - 手で書きたくない感じ（HLSL 以前のアセンブラっぽい見た目）
    - （AGAL って Adobe Graphics **Assembly** Language の略だしね）
    - そこで普通はその辺を中でやってくれているライブラリを使う

例えば Starling のソースを読んでいくと、中で AGAL の文字列を
`com.adobe.utils.AGALMiniAssembler` に渡しているのが見える

    // QuadBatch.as の中から抜粋
    vertexShader =
        "m44 op, va0, vc1 \n" + // 4x4 matrix transform to output clipspace
        "mul v0, va1, vc0 \n";  // multiply alpha (vc0) with color (va1)
    
    fragmentShader =
        "mov oc, v0       \n";  // output color

### Stage3D 向けライブラリ

- Adobe が公式サポートしているものがある（どちらもオープンソース）
    - 2D 向け： [Starling](http://gamua.com/starling/)
    - 3D 向け： [Away3D](http://away3d.com/)

___

- Stage3D 黎明期には色々出てきていたが、Adobe 公認のものが生き残った感じ？
    - 3D のほうよく知らないけど、少なくとも 2D は Starling 一強っぽい
    - Starling はそれなりにユーザもいるし、開発も続いていて好印象


## これくらいやれる

- 普通の 2D ゲームで FPS 60 は出る
    - iPhone4S や 2012 年くらいの Android で概ね 60 出るくらいの感じ
    - スマフォのゲームとして実用に足りるレベル

### 僕が作ったやつ（ブラウザで動くよ）

- (2012) [Mr.WARP ](http://www.tatsuya-koyama.com/4.0/html/tkworks/game/works/mrwarp.html)
- (2013) [iro-mono](http://www.tatsuya-koyama.com/4.0/html/tkworks/game/works/iromono.html)
- あと自作フレームワーク作ってるときの
  [試作品]({{ urls.base_path }}krew-framework/laboratory) とか

<div class="image-autofix">
  <img src="{{urls.media}}/screenshot/mrwarp1.jpg">
  <img src="{{urls.media}}/screenshot/mrwarp2.jpg">
  <img src="{{urls.media}}/screenshot/mrwarp3.jpg">
</div>

<div class="image-autofix">
  <img class="white" src="{{urls.media}}/screenshot/iromono1.jpg">
  <img class="white" src="{{urls.media}}/screenshot/iromono2.jpg">
  <img class="white" src="{{urls.media}}/screenshot/iromono3.jpg">
</div>


### 世のゲームの一例

#### Flash + Stage3D

- [スクエニ レジェンドワールド](http://www.jp.square-enix.com/legendworld/)
    - [技術記事](http://gallery.adobe-web.jp/web/legendworld/)
        - かなりリッチな見た目。これがブラウザで動くのはなかなかインパクトある。
          開発ツールなども Adobe AIR で構築した様子

#### Adobe AIR - iOS / Android

- [PyroJump](http://pyrojump.com/)
- [パズ億](https://play.google.com/store/apps/details?id=jp.mbga.a12015865.lite&hl=ja)
- [BABEL](http://babeltheking.com/eng)

___

- [Starling の showcase たくさん](http://gamua.com/starling/games/)
    - 海外では結構使われてるんだなーという印象


## AIR でのアプリ開発

### 開発フロー

- IDE は公式の FlashBuilder を使うのが無難
- Windows なら FlashDevelop のような代替がある
- お金をかけずにコマンドラインでやることもできるがデバッグは辛くなる

{{# image }}
  krewfw/ide.png
{{/ image }}

- 基本は ADL（シミュレータ）でデバッグ（結構立ち上がり早くて嬉しい）
    - AIR だけでできないことは iOS / Android のネイティブ拡張が必要
    - ネイティブ拡張の検証には iOS シミュレータとか実機デバッグが必要
    - 実機検証は結構イテレーションに時間かかるのがネック

### Flash の GUI で画面とか制御組んだりできるの？

- 昔の Flash ゲームとかそうやって作るアーティストがいたのでそういうイメージあると思う
    - Flash はレイアウトやアニメーションを GUI で作ってオブジェクトやタイムラインにコード書き込めた
    - こういったことは AIR でもできるけど、前述の通りソフトウェアレンダリングになるので遅い

___

- GPU で描画されるものを作るなら普通のネイティブアプリ開発と変わらず、基本的にコードをがしがし書く
    - Flash から DragonBones でデータを吐き出してそれを読み込んで再生、とかはできるけど制御はプログラム側

### Android ビルド

- AIR のコンパイラ群を使って apk をビルドする
    - ビルド時間は 30 秒程度かな
- AIR のランタイムを内包（captive）するのが普通だが、
  ランタイムを分けてアプリのサイズを小さくすることもできる
    - この場合、ユーザはランタイムを別途 Google Play から落としてインストールする必要がある（誘導は出る）
- 内部的には AIR ランタイム上で中間コードが動いてる

### iOS ビルド

- AIR のコンパイラ群を使って ipa をビルドする
    - これが時間かかる。MacBook Air 2013 で 7 分くらい
    - デバッグビルドは速いが、動作がとても遅い
- 頑張って AS3 のコードをネイティブコードに変換して、アプリを作成してる
    - iOS の制約上、こうせざるを得ない
    - その代わり中間コード動かすよりオーバヘッド小さくてすむけどね
- ビルドを高速に行う新型 packager も開発されてはいるが、
  2014 年 9 月現在、まだ stable とは言えない
    - （手元で試してみた限りでは、ビルドは 1 分程度で終わるが、
        できあがるものがバグっていたり動作が遅かったりして使い物になっていない）

### プロファイリング

- [Adobe Scout](http://www.adobe.com/jp/joc/gaming/scout.html)
  という専用のプロファイラが FlashBuilder とは別に作られた
- これは見た目もクールで、かなり使い勝手よくてイケてる
    - 立ち上げておけば勝手に計測してくれる。（Web 上の Flash でも！）
- FlashBuilder 側にもプロファイラはあるが、今後は基本的に Scout を使えばいいだろう

{{# image }}
  screenshot/adobe_scout.jpg
{{/ image }}

- CPU 負荷、描画負荷、メモリ消費についてそれぞれ追いやすく、実際に業務レベルで役に立った
    - 特に描画については **全フレームにおいて Stage3D の描画命令をキャプチャ** できる
    - フレーム単位でその時の画面の絵と、どういう順番で Draw Call が呼ばれているかを確認できる。
      描画まわりのボトルネックを見つけるには非常に有用

#### モバイル実機のプロファイリング

- 実機と Mac を同じネットワークにつなぎ、Scout のコンパニオンアプリを起動しておくことで
  実機でも Scout によるプロファイリングが可能
- とはいえプロファイリング情報（Telemetry）をネットワーク越しに送るのが結構負荷高いので、
  それがプロファイリングそのものの邪魔をしてしまう、というのはある
    - (プロファイリング自身の負荷がどれくらいか、というのは見れる)
- これやる時は FPS 下げとくとかすればよいかもしれない

### ネットワークまわりのデバッグ

- FlashBuilder にはその辺のサポートは無いみたいで切ない
    - ネットワークモニタというのがあるが、これは Flex プロジェクト向け？

> - [データサービスにアクセスするアプリケーションの監視](http://help.adobe.com/ja_JP/Flex/4.0/UsingFlashBuilder/WS0310FF63-C8B3-43d3-9764-3B197D07B781.html)
>
> 【引用】ネットワークモニターでは、ピュア ActionScript および Library
>  プロジェクトを使用して作成されたアプリケーションをサポートしていません。

- 仕方ないので URLRequest による通信の監視には、
  単純な trace ログや [charles](http://www.charlesproxy.com/)
  みたいな web proxy を利用した


## 他のマルチプラットフォーム系との比較

- 他の選択肢として Cocos2D, Unity あたりを想定

### アドバンテージ

- **赤魔導士（Flasher）** が集まる
    - AIR / Flash 界隈にはコードとアート両方やれるような人材が多い
    - あなたがそういう人たちと仕事をしたいなら AIR というのはちょうどよい舞台
- **アニメーション・演出づくりに Flash が使える**
    - DragonBones みたいな公式サポートのライブラリがすでにあるので、Flash のアセットは組み込みやすい
    - Flash の UI は 2D アニメツールの定番感がある。Flash になじみのあるアーティストは多い
    - アーティストは、社内ツール使うよりかは Flash の方がキャリア的に嬉しい
- ちょっとしたデモとかブラウザで動かせる
- ADL が何気に軽やか（ビルドして立ち上がりまで 5 秒）
- プロファイラの **Adobe Scout** がイケてる
- Adobe（企業）がサポートしてくれる
- 周辺ライブラリはそれなりにある
    - スマフォ向け UI の Feathers や外部連携用の Native Extension など

### ディスアドバンテージ

- Android は中間コードだから負荷が気になる（端末熱くなる）
- iOS はネイティブ相当だが、リリースビルドに 7 分かかる
- 音源の再生は mp3 以外の圧縮形式は公式ではサポートされていない
    - ogg 再生は Native Extension とか作って色々頑張ってみたけど音が途切れたりで完璧にはうまくいかなかった

### ここはトレードオフ

- AS3 はそれなりに書きやすく楽ができるが、C 系の言語でメモリをきっちりコントロール、みたいなことはできない
    - GC の言語なので Object Pooling とかはちゃんとやらないとちょいちょいカクつく
    - （まあこの辺はゲーム作るなら当たり前だけど）

___

- いざという時（Apple が急に仕様変えたとか）に Adobe の対応を待たなくてはならないこともある
    - その代わり Adobe が企業レベルのサポートをしてくれる恩恵はある
- Cocos などと異なり、AIR 自体はオープンソースではない
    - ビジネスレベルで守られているとも言える
    - 周辺ライブラリは大体オープンソースだよ

### まあ他のソリューションでも似たような話だろう系

- 実機デバッグがイテレーションに時間かかって面倒
- AIR 標準でできないことは Native Extension が必要
- これからも生きていけるかどうかは Adobe さん次第なところがある


## 僕らはこう作った

- ベースに [Starling](http://gamua.com/starling/)
- ゲームロジックのフレームワークレイヤーは自作した：
  [krewFramework]({{ urls.base_path }}krew-framework/top)
- アニメーションと UI を [DragonBones](http://dragonbones.effecthub.com/) で
- リストみたいなタッチデバイス向け UI は [Feathers](http://feathersui.com/)

### krewFramework

- 僕が自作した AS3 向け汎用ゲームフレームワーク
    - 詳しくは [こちら]({{ urls.base_path }}krew-framework/top)

<div style="text-align: center;">
  <img class="radius" src="{{urls.media}}/krewfw/krewfw_logo.png"
       style="width: 100%; max-width: 800px;" />
</div>

- 担う部分
    - Scene 遷移の管理と Scene スコープのリソース管理
    - Actor 指向のメッセージングを用いたゲームオブジェクトの協調動作
    - Layer 単位での描画順序、時間軸、タッチ有効・無効の制御
    - 手軽に書ける Tween やタスクのスケジューリング
    - 手軽に書ける BGM / SE 再生
    - 簡単な衝突判定
    - ゲームでありがちな計算をするユーティリティ
    - ゲームでありがちなコンポーネントを提供
        - 階層型ステートマシン
        - 非同期処理を書きやすくするライブラリ

___

- （ここはフレームワークの外でやったけどいずれ汎用化したい）
    - ネットワークのレイヤー
    - アセットの動的ダウンロードの管理機構
    - Client Side のデータベースのモデル
    - UI のデータ読み込んで画面構築するような部分


### DragonBones

- [DragonBones 公式ページ](http://dragonbones.effecthub.com/)
    - Adobe から公式サポートを受けているオープンソースのプロジェクト
- Flash で作ったアニメーションを Stage3D で再生するためのライブラリ
    - 簡単に言うと
      [spine](http://ja.esotericsoftware.com/) とか
      [SpriteStudio](http://www.webtech.co.jp/spritestudio/)
      あたりのことを Flash でやるというもの
- Flash の Extension と、AS3 / JS などの再生ライブラリからなる
- 普通の Flash の作り方と比べて、ちょっとクセはある
- テクスチャはちゃんとアトラスにまとめてくれる

___

- Flash はこの手のツールとしては相当枯れているので、使いやすいというのが利点

### パラパラアニメも併用

- 小さくて物量があるキャラクターなどは普通に Sprite アニメ
- これも Flash から書き出し
    - Starling は MovieClip をアニメーション再生する機能を持つ


### UI や演出の開発

- 固定演出はもう Flash 作るノリでやれるので、Flash 使う人にとっては楽
- DragonBones をウインドウやメニューのような UI の開発にも使うことで、
  見た目の組み立てやちょっとしたアニメーションを **アーティスト駆動** にすることができる
- 組み込みは普通にエンジニアがコード書いてやってる
    - 新規 UI のつなぎこみ
    - ボタンなどのハンドリング
    - 文字の当て込み（領域と色を Flash 側で作っておく）
    - 動的に変わる画像の差し替えなど
- ボタン UI の挙動とかは、Flash サイドのラベルの命名規則で自動的にやれるようにライブラリ書いた


## 周辺ツール

### Creative Cloud

アート寄りの人であれば PhotoShop とかの兼ね合いで **Creative Cloud** を契約していることが多いと思う。
Creative Cloud で一通り揃う。

- Adobe Flash Builder + Gaming SDK
- Adobe Flash Pro + DragonBones
- Adobe Scout

### オープンソースのライブラリ（メジャーどころ）

#### 描画エンジン・ゲームエンジン
- [Starling](http://gamua.com/starling/)
- [Away3D](http://away3d.com/)
- [Citrus game engine](http://citrusengine.com/)

#### アニメーション
- [DragonBones](http://dragonbones.effecthub.com/)

#### UI コンポーネント
- [Feathers](http://feathersui.com/)

#### 物理エンジン
- [Box2D](http://box2dflash.sourceforge.net/)
- [Nape Physics](http://napephys.com/)

#### その他

- 各種 Native Extension とかちょっとしたライブラリとか、探せばそれなりにある
    - ここで色々探せる：[AS3 Game Gears](http://www.as3gamegears.com/)

## 最後に

全てを解決する魔法は無いので、あなたはあなたの好みと要件に合ったソリューションを選ぶのがよいでしょう。
僕は Adobe AIR まわりのツール群は結構好きです。
Adobe さんがやめないうちは、もうしばらくこれでゲームを作ると思います。


