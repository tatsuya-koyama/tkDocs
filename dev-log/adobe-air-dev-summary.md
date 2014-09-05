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

- スマフォアプリのゲーム開発、商用リリース
    - iOS, Android
    - Game Server あり
    - 課金あり
    - フレンド要素あり（ほんわか系）
    - 外部サービスとの連携あり
    - 動的アセットダウンロードあり

### 規模感とチーム構成

- 人月はざっくり 10 人強 x 8 ヶ月くらい
- （+ 音とデザインのアウトソースはあり）
    - Producer 1
    - Project Manager / Level Designer 1
    - Client Programmer 2+
    - Server Engineer 2+
    - Art Director 1
    - Artist 2+
    - Technical Artist 1
    - Assistant 1+

> ※ 途中細かく変動はあり

- 私 → 主に Client サイドの Lead Programmer

## 最初に所感

- 世間のイメージは「Flash は死んだ」「AIR って遅くてゲームには使えない」な気がするけど…
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

> よくある勘違いに「AIR って普通に Flash 再生できるんだよね」というのがあるが、
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

- Stage3D 用のシェーダ言語
- GLSL, HLSL, Cg みたいな最近のやつと比べてずっと **低級**
    - 手で書きたくない感じ（HLSL 以前のアセンブラ感）
    - そこで普通はその辺を中でやってくれているライブラリを使う

### Stage3D 向けライブラリ

- Adobe が公式サポートしているものがある（どちらもオープンソース）
    - 2D 向け： [Starling](http://gamua.com/starling/)
    - 3D 向け： [Away3D](http://away3d.com/)

___

- Stage3D 黎明期には色々出てきていたが、Adobe 公認のものが生き残った感じ
    - 3D のほうよく知らないけど、少なくとも 2D は Starling 一強
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

### 世のゲーム

#### Flash + Stage3D

- [スクエニ レジェンドワールド](http://www.jp.square-enix.com/legendworld/)
    - [技術記事](http://gallery.adobe-web.jp/web/legendworld/)

#### Adobe AIR - iOS / Android
- [PyroJump](http://pyrojump.com/)
- [パズ億](https://play.google.com/store/apps/details?id=jp.mbga.a12015865.lite&hl=ja)
- [BABEL](http://babeltheking.com/eng)

___

- [Starling の showcase たくさん](http://gamua.com/starling/games/)


## AIR でのアプリ開発

### 開発フロー

- 基本 ADL（シミュレータ）でデバッグ（立ち上がり早い）
    - AIR だけでできないことは iOS / Android のネイティブ拡張が必要
    - ネイティブ拡張の検証には iOS シミュレータか実機デバッグが必要
    - 実機検証は結構イテレーション時間かかる

### Android ビルド

- AIR のコンパイラ群を使って apk をビルドする
    - ビルド時間は 30 秒程度かな
- AIR のランタイムを内包（captive）するのが普通だが、
  ランタイムを分けてアプリのサイズを小さくすることもできる
    - この場合、ユーザはランタイムを別途マーケットから落としてインストールする必要がある（誘導は出る）
- 内部的には AIR ランタイム上で中間コードが動いてる

### iOS ビルド

- AIR のコンパイラ群を使って ipa をビルドする
    - これが時間かかる。MacBook Air 2013 で 7 分くらい
- なんと AS3 のコードをネイティブコードに変換して、アプリを作成してる
    - iOS の制約上、こうせざるを得ない
    - その代わり中間コード動かすよりオーバヘッド小さくてすむけど
- ビルドを高速に行う新型 packager も開発されてはいるが、
  2014 年 9 月現在、まだ stable とは言えない
    - （ビルドは 1 分程度で終わるが、できあがるものがバグっていたり動作が遅かったりして使い物になっていない）


## 他のマルチプラットフォーム系との比較

- ToDo: Cocos2D, Unity との比較

### アドバンテージ

- **赤魔導士（Flasher）** が集まる
    - AIR / Flash 界隈にはコードとアート両方やれるような人材が多い
    - あなたがそういう人たちと仕事をしたいなら AIR は有用
- Flash の技術を活かしやすい
    - Flash の UI は 2D アニメツールの定番感ある、アーティストなら多くの人が扱える
    - アーティストは、社内ツール使うよりかは Flash の方がキャリア的に嬉しい
- ちょっとしたデモとかブラウザで動かせる
- ADL が何気に軽やか（ビルドして立ち上がりまで 5 秒）
- プロファイラの **Adobe Scout** がイケてる
- Adobe（企業）がサポートしてくれる
- スマフォ向け UI の Feathers など、周辺ライブラリはそれなりにある

### ディスアドバンテージ

- C++ でチューニングしたやつよりは当然ながらオーバヘッド大きい（メモリ消費とか）
- Android 熱くなりやすい（中間コードだし）
- iOS はネイティブ相当だが、ビルドに 7 分かかる
- GC の言語なので Object Pooling とかちゃんとやらないとちょいちょいカクつく
- AIR 標準でできないことは Native Extension 必要
- 実機デバッグがイテレーションに時間かかって面倒
- ogg 再生は色々頑張ってみたけどうまくいかなかった
- AIR 自体はオープンソースではない
- 世間では「Flash が死んだ」というネガティブイメージがある
- （これからも生きていけるかどうかは Adobe さん次第なところがある）


## 僕らはこう作った

- ベースに **Starling**
- ゲームロジックのフレームワークレイヤーは自作した
    - [krewFramework]({{ urls.base_path }}krew-framework/top)
- アニメーションと UI を **DragonBones** で

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
- DragonBones を UI の開発にも使うことで、見た目の組み立てやちょっとしたアニメーションを
  アーティスト駆動にすることができる
- 組み込みは普通にエンジニアがコード書いてやってる
    - 新規 UI のつなぎこみ
    - ボタンなどのハンドリング
    - 文字の当て込み（領域と色を Flash 側で作っておく）
    - 動的に変わる画像の差し替えなど
- ボタン UI の挙動とかは、Flash サイドのラベルの命名規則で自動的にやれるようにライブラリ書いた


## 周辺ツール

### Creative Cloud

アート寄りの人であれば PhotoShop とかの兼ね合いで Creative Cloud 入ってることが多いと思う。
CC 入ってれば事足りる

- Adobe Flash Builder + Gaming SDK
- Adobe Flash Pro + DragonBones
- Adobe Scout

### オープンソースのライブラリ

- Starling
- Away3D
- DragonBones
- Feathers
- Box2D
- Nape Physics

### その他

- 各種 Native Extension とかちょっとしたライブラリとか、探せばそれなりにある
    - 参考：[AS3 Game Gears](http://www.as3gamegears.com/)




