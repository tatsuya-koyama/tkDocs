---
title: 'Flash Builder での開発メモ'
date: '2014-01-06'
description:
categories: []
tags: [anything, Game-Development, Flash]
position: 111
---

# Flash Builder での開発メモ

## プロジェクトのおすすめファイル構成

- 基本的にワンソースでいけるよ、というのがウリの AIR だが、
  プラットフォームごとにプロジェクトを分けておくのが無難
- Native Extension とかやると分けざるを得ないしね
- 各 project の Main から、カスタマイズの処理を走らせた後に
  共通ソースの Main をキックする形にする

        Your_Git_Repository/
        ├── asset/
        │   ├── asset/
        │   └── workfile/
        │
        ├── core-src/
        │   └── your_game_package/
        │
        ├── lib/
        │   └── *.swc
        │
        ├── projects/
        │   ├── android-project/
        │   ├── local-debug-project/
        │   ├── ios-project/
        │   └── web-project/
        │
        ├── Makefile
        └── build/

___

- project 以下のファイルはこんな感じになる
- ここに FlashBuilder 用の .project などが入る
- DebugMain.as は core-src/ 以下の共通の Main を new する

        projects/local-debug-project/
        ├── .actionScriptProperties
        ├── .project
        ├── .settings
        ├── bin-debug
        │   └── (Files you built)
        │
        └── src
            ├── DebugMain-app.xml
            ├── DebugMain-config.xml
            └── DebugMain.as

## Git 管理

- .project ファイルは git 管理しなければならない
    - ここにソースパスやライブラリパスが書かれるから
- でもファイルパスって人によって変わっちゃうよね。どうするの？

___

- リポジトリまでのベースパスを表すパス変数の名前を決める
    - 例えば HOGE_ROOT でいくとする
- 各個人が FlashBuilder のワークスペースに HOGE_ROOT というパス変数を作る
    - HOGE_ROOT = 自分がリポジトリを clone したパス、とする
    - .project 内のパスは、HOGE_ROOT を使ってリポジトリからの相対パスで指定する
    - HOGE_ROOT はワークスペースの .metadata 以下の深いところに保存されている
    - これは git 管理しない

### ワークスペースとは

- 文字通り Flash Builder の作業場
- ここに自分が作業したいプロジェクトを複数読み込む
- 一瞬、複数の project をまとめた上位のコンテナに見えるが、そうではなくて個人ごとに持つもの
- 複数のワークスペースは同時に開けない
    - ワークスペース切り替えると、Flash Builder 再起動するしね
- というか基本的にワークスペースを切り替えることはあまり想定されていないと思う
    - エディタのカラーの設定とかもワークスペースレベルに保存されている

## Flash Builder でプロジェクト新規作成するときの作業

### リポジトリ用のパス変数作成

- リポジトリのルートのパスのパス変数名を決める。たとえば PIYO_ROOT とする
- PIYO_ROOT というパス変数を作る
    - Flash Builder -> 環境設定 -> 一般 -> ワークスペース -> リンクされたリソース
    - PIYO_ROOT という名前でリポジトリまでのパスを指定

> - この変数は Git 管理しないので個々人で設定してもらう必要がある
>     - ただしここで決めた PIYO_ROOT という名前は .project の中に入って Git 管理される

### プロジェクトの新規作成と、パスの設定

- ファイル -> 新規 -> ActionScript モバイルプロジェクト
    - （モバイルだと AIR シミュレータでデバッグできるので、Flash のローカルテスト用でもモバイルが無難）
- プロジェクト名には hoge-game-android-project みたいな分かりやすい名前をつけよう
    - ワークスペースに読み込まれたときに他のプロジェクトと見分けがつけばよい
- パスの指定
    - ライブラリパスに、swc が置かれてるディレクトリを指定
    - ソースパスに、共通 Main があるディレクトリや、外部ソースのディレクトリを指定
    - 動的にロードする画像などのアセットがあるディレクトリも、ソースパスで指定する
        - build ディレクトリ以下にアセットがコピーされるようになる

### アセットのパス指定について

- 以下の items/ をソースパスに指定した場合、build 直下に asset/ および workfile/ がコピーされることになる

        items/
        ├── asset/
        └── workfile/

- この場合、ソースコードからのパス指定は "asset/..." から始まる

### config の XML 指定

- FPS や背景色などの指定には以下の方法がある
    - 1. ソースに埋め込む
    - 2. コンパイルオプションで直接指定
    - 3. XML の設定ファイルを用意し、コンパイル時に使うように指定

___

- 管理しやすくするためには、XML の設定ファイルを用意するのが無難だろう
- 用意した XML をコンパイルに使うよう指定するには：
    - プロジェクトのプロパティ -> ActionScript コンパイラー
- 「追加コンパイラー引数」に以下のように追記する

        -load-config+="AndroidMain-config.xml"

- コマンドラインで mxmlc 直接叩いてビルドすると、Main-config.xml みたいな名前のファイルがあれば
  勝手に使ってくれるんだけどね


## ハマった系

### iOS 実機デバッグうまくいかない

- 環境
    - FlashBuilder 4.7
    - XCode 5.0 くらい
    - iOS 5.1 の iPhone 4S
- デバイス実行するとできるアプリを起動すると即落ちる
- コマンドラインで adt でパッケージしたやつは普通に動いた
- 落ちたときの端末のエラーログ

        <Error>: -[__NSCFDictionary objectForKeyedSubscript:]: unrecognized selector sent to instance 0x961430

- これでググったら同じような症状の
  [Stack Overflow](http://stackoverflow.com/questions/16744689/air-native-extension-failing-on-nsdictionary-objectforkeyedsubscript-in-ios-5-1)
  出てきた
    - これを参考に、iOS プロジェクトの「デバッグの構成」->「起動をカスタマイズ」から

            // 俺は Xcode 5.0 なので
            Applications/Xcode.app/Contents/Developer/Platforms/
            iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

    - これを `-platformsdk` に設定したら動いた


<br/><br/><br/><br/>

