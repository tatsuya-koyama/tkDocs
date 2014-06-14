---
title: 'AIR SDK のセットアップ'
date: '2013-12-12'
description:
categories: []
tags: [anything, krewFramework]
position: 2001
---

# AIR SDK のセットアップとサンプルのビルド

## Adobe AIR ゲーム開発環境

<div style="float: right;">
  <img class="normal" src="{{urls.media}}/krewfw/adobe_air_logo.jpg" />
</div>

**Mac での開発を前提に手順を示します。**

Adobe AIR / Flash 向けのビルドを行うには、以下の方法があります。

- (1) コマンドラインでビルドする
- (2) FlashBuilder でビルドする

コマンドライン版は原始的ですがシェルとの連携が軽やかで、お金もかかりません。

FlashBuilder を使うとお金はかかりますが、IDE で人間らしいコーディングとデバッグができます。


## コマンドラインでのビルドの準備

ここではまず、コマンドラインでビルドと実行を行うための手順を示します。

<div style="text-align: center;">
  <img class="photo" src="{{urls.media}}/krewfw/cmdline-build.png" />
</div>

### AIR SDK の入手

- 以下から Adobe AIR SDK をダウンロードし、任意の場所に展開します
    - [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html)
    - 2014 年 6 月現在、筆者が動作確認しているバージョンは、14.0.0.110 です

> 【Note】Adobe AIR のバージョンは、2014 年 4 月に出た Ver.13 から
> Flash Player とメジャーバージョンを一致させたものになっています。
> そのため 4.0 から 13.0 に飛んでいて、5.0 〜 12.0 は欠番になっています。

___

> 【Note】AIR SDK には、新型のコンパイラ（ASC2.0）のバージョンと、
> 旧型のコンパイラのバージョンがあります。ASC2.0 を用いた方が生成される swf
> のパフォーマンスは向上するとされています。また、Adobe Scout で詳細な情報を
> プロファイリングするためにも ASC2.0 を使用する必要があります。

> <br/>
> ただし ASC2.0 からは 2 回目以降のビルドを早くするための incremental
> オプションが廃止になりました。コマンドラインで ASC2.0 版を使うと
> ビルドのイテレーションが従来よりも遅くなります。

> <br/>
> FlashBuilder では 2 回目以降のビルドを早くするプロセスをメモリに常駐させているようで、
> イテレーションが遅くなるということはありません。FlashBuilder を使わず
> コマンドラインでビルドする場合は、旧型を使うと開発は楽です。

### Flex SDK の入手

- 以下から Adobe Flex SDK をダウンロードし、任意の場所に展開します
    - [Adobe Flex SDK](http://www.adobe.com/devnet/flex/flex-sdk-download.html)
    - 2014 年 6 月現在、筆者が動作確認しているバージョンは、4.6 です

### Java 1.6 の準備

- コンパイラなどのコマンド実行に Java 1.6 以上が必要です
    - Mac であれば大抵デフォルトで入っていると思います
    - 以下でチェックして、入ってなかったら頑張って入れてください

            $ java -version

### AIR SDK を Flex SDK にマージ

- AIR SDK の中身を Flex SDK にマージする必要があります

        $ ditto air_sdk/ flex_sdk/

> 【Note】 Windows でフォルダをフォルダ内に投げ込むと中身が上書きされていくのに対し、
> Mac の Finder では同名のフォルダは置き換えになってしまいます。
> マージする場合には ditto コマンドなどを使用します。

- SDK の bin ディレクトリにコンパイラなどのコマンドが置かれていますので、ここにパスを通します。
  bash だったら `~/.bashrc` に以下を書くなど：

        export PATH=$PATH:path/to/flex_sdk_merged_air_sdk/bin

### コンパイラ mxmlc の動作確認

- 以下のコマンドで `version 2.0.0` などと表示されれば準備完了です

        $ mxmlc -version

> ASC2.0 でない古いコンパイラの SDK を使用した場合は、`version 4.6.0` などと表示されます



## テストアプリのビルド

- `laboratory/` ディレクトリ以下には、krewFramework の動作検証や
  世の AS3 のライブラリの実験をしたときのコード集が入っています
- これをビルドして、ビルド環境のテストと出来上がるものの手触りを確認してみましょう

### ゴールイメージ

- ビルドに成功するとこういう感じの動作画面が見れるはずです
    - [Laboratory](/krew-framework/laboratory)
    - タイトルから遷移した先のメニューから、複数のデモが見れます

<div style="text-align: center;">
  <img class="normal" src="{{urls.media}}/krewfw/krew-lab-image.png" />
</div>

### krewFramework のソースコードの入手

あなたが Git を使える前提で話を進めます。
（Git についてのリファレンスは
[Pro Git](http://git-scm.com/book) がおすすめ）

- [GitHub](https://github.com/tatsuya-koyama/krewFramework) から clone します

        $ git clone git@github.com:tatsuya-koyama/krewFramework.git

### swf のビルドと adl での実行

- コマンドラインで `krewFramework/laboratory/` 以下に移動し、make します
- `make debug` で PC 向けデバッグ用 swf を作成、`make run` で adl (AIR Debug Launcher) 上で実行します

        $ cd laboratory/
        $ make debug
        $ make run

### Android 向け apk のパッケージング

- コマンドラインで `krewFramework/laboratory/` 以下に移動し、以下を叩きます

        $ cd laboratory/
        $ make air-android
        $ make cert    # 初回だけ必要
        $ make android

        # Android 実機を USB で接続し、adb にパスが通った状態で
        $ make install-android

何をやっているかは
[Makefile の中身](https://github.com/tatsuya-koyama/krewFramework/blob/master/sample-game/Makefile)
をご確認ください。


## FlashBuilder でのビルドの準備

- FlashBuilder は Adobe 公認の IDE であり、AIR / Flash 向けのゲーム開発においては
  最もポピュラーなソリューションでしょう
- ただし 2014 年 6 月現在、SDK のアップデート周りが不十分な対応になっており、
  多くの人がここで苦労していますので注意してください

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/krewfw/ide.png" />
</div>

### 罠の多い SDK のアップデート

- FlashBuilder が最新の SDK を使うようになっていない場合、
  最新のもの（2014 年 6 月現在、Adobe AIR SDK 14.0, Adobe Flex SDK 4.6）
  を使うようにするには SDK の入れ替え作業が必要になります
- [公式記事](http://helpx.adobe.com/flash-builder/kb/overlay-air-sdk-flash-builder.html)
  がありますが、**この通りにやってもうまくいかないと思います**（つらい）
- 筆者は [ここの PDF](http://geekabanga.files.wordpress.com/2013/04/upgrading-flash-builder-4-7-air-sdk-3-7.pdf)
  のやり方に則って作業したところ、無事に入れ替えができました

> 【Note】この PDF は Windows 向けです。フォルダをマージするところは Mac では
> `ditto` コマンドなどを使う必要があります

### 本当の FlashBuilder 向け SDK アップデート手順

- 上記 PDF に従ったやり方をまとめておきます
- 以下の 3 点をダウンロードして手元に用意します

1. 新しい Adobe AIR SDK (with ActionScript Compiler 2.0)
1. 旧式の Adobe AIR SDK (without ASC2)
1. Flex SDK

- 以下からダウンロードできます
    - [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html)
    - [Adobe Flex SDK](http://www.adobe.com/devnet/flex/flex-sdk-download.html)

___

- 新しい AIR SDK を **NEW-AIR-SDK** と表記します
- 旧式の AIR SDK を **OLD-AIR-SDK** と表記します

___

- (1) Flash Builder が参照している AIRSDK のディレクトリを、展開した **NEW-AIR-SDK** で置き換えます
    - Mac で Flash Builder 4.7 のデフォルト設定なら、以下にあるでしょう
    - /Applications/Adobe Flash Builder 4.7/eclipse/plugins/com.adobe.flash.compiler_4.7.0.349722/AIRSDK

> ・こんな階層にあるディレクトリを手で置換するのかと驚かれるでしょうが、真実です

___

- (2) 展開した Flex SDK に、展開した **OLD-AIR-SDK** をマージしたものを用意します
    - 上で既出ですが、Mac の場合は Finder で投げ込むのではなく ditto コマンドなどを使用してください

            $ ditto AdobeAIRSDK_14/ flex_sdk_4.6/

> ・こんな煩わしいことをやらなくてはならないのかと疑われるでしょうが、真実です

___

- (3) (2) で作ったものを Flash Builder が参照可能な場所に置きます
    - デフォルトにならうなら以下が無難です
    - /Applications/Adobe Flash Builder 4.7/sdks/
    - `4.6.0_with_14` などと名前をつけておくと分かりやすいでしょう

___

- (4) Flash Builder を起動し、Flex SDK の参照先を指定します
    - Flash Builder → 環境設定 → インストールされている Flex SDK
    - (3) で配置したパスを追加して、チェックをつけてください

___

- 以上で完了です。お疲れさまでした


### laboratory をビルドするための準備

- まず、プロジェクトの場所を FlashBuilder のワークスペースレベルに設定する必要があります
    - Flash Builder → 環境設定 → 一般 → ワークスペース → リンクされたリソース
    - **ここに `KREW_ROOT` という名前でパス変数を作り、**
      **clone した krewFramework のリポジトリまでのパスを設定して下さい**
    - `.project` ファイル内には `KREW_ROOT/laboratory/core-src` のようにパス指定がされているので、
      これでプロジェクトのパスが通るようになります

> **【Hint】FlashBuilder のワークスペースとは**

> - ワークスペースは文字通りの作業場で、ユーザごとに持つもの（git 管理しない部分）です。
> ユーザはここに任意の project を複数読み込んで、ビルドやデバッグを行います。
> （複数の project をまとめたコレクションではありません。）

> - リポジトリまでのファイルパスなど、ユーザごとに異なるようなものは
> 環境変数としてワークスペースレベルに保存します。
> （git のファイルに含めてしまうとチーム開発の際に他の人に迷惑がかかるのでご注意を。）

### project 構成について

- Adobe AIR はマルチプラットフォーム向けのミドルウェアで、概ねワンソースで動かせますが、
  アセットのパス指定や AIR 独自の機能（Flash に無い API）、
  OS 独自の機能（ANE: ネイティブ拡張）を使う場合はその部分のコードを分ける必要があります
- そのため project は android, web などとプラットフォームごとに分かれています
- 各プラットフォーム向けに機能をスイッチするコードを各 project のエントリで実行してから、
  共通の Main をキックするという戦略です
      - （Dependency Injection パターン）

### project をインポートして実行

- 左側にあるペーンのパッケージエクスプローラで右クリック → インポート
    - 既存プロジェクトをワークスペースへ
    - projects/debug-project などを指定

___

- `KREW_ROOT` のパス変数の設定が正しければ、プロジェクトの「実行」または「デバッグ」
  で動作確認できます
- 初回は実行構成の設定画面が開きますので、以下のように適当に設定してください
    - ターゲットプラットフォーム： Google Android
    - 起動方法： AIR シミュレータ
    - デバイス： （適当に）


<br/><br/><br/>

