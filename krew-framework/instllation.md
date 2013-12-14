---
title: 'セットアップとサンプルゲームのビルド'
date: '2013-12-12'
description:
categories: []
tags: [anything, krewFramework]
position: 2
---

# セットアップとサンプルゲームのビルド

## Adobe AIR ゲーム開発のセットアップ

- [ToDo] _Flash Builder 用の（罠が多くて辛い）セットアップ手順についてもまとめる_

### AIR SDK と Flex SDK の準備

Mac での開発を前提に手順を示します。

- 以下から Adobe AIR SDK をダウンロードし、任意の場所に展開します
    - [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html)
    - 筆者が動作確認しているバージョンは、3.9 です

___

- 以下から Adobe Flex SDK をダウンロードし、任意の場所に展開します
    - [Adobe Flex SDK](http://www.adobe.com/devnet/flex/flex-sdk-download.html)
    - 筆者が動作確認しているバージョンは、4.6 です

___

- コンパイラなどのコマンド実行に Java 1.6 以上が必要です
    - 以下でチェックして、入ってなかったら頑張って入れてください

            $ java -version

___

- AIR SDK の中身を Flex SDK にマージする必要があります

        $ ditto air_sdk/ flex_sdk/

> [Note] Windows でフォルダをフォルダ内に投げ込むと中身が上書きされていくのに対し、
> Mac の Finder では同名のフォルダは置き換えになってしまいます。
> マージする場合には ditto コマンドなどを使用します。

- SDK の bin ディレクトリにパスを通します。bash だったら ~/.bashrc に以下を書くなど：

        export PATH=path/to/flex_sdk_merged_air_sdk/bin:$PATH

- 以下のコマンドで version 4.6.0 などと表示されれば準備完了です

        $ mxmlc -version


## サンプルゲームのビルド

- [ToDo] _サンプルゲームをゲームと呼べるようなものにする_
- [ToDo] _Flash Player での再生確認用の html を用意する_
- [ToDo] _Flash Builder 用のプロジェクトファイルを同梱する_

### ゴールイメージ

- ビルドに成功するとこういう感じの動作画面が見れるはずです
    - [Sample Game Demo](/krew-framework/sample-demo)

### krewFramework のソースコードの入手

あなたが Git を使える前提で話を進めます。
（Git についてのリファレンスは
[Pro Git](http://git-scm.com/book) がおすすめ）

- [GitHub](https://github.com/tatsuya-koyama/krewFramework) から clone します

        $ git clone git@github.com:tatsuya-koyama/krewFramework.git

- 以下のようなファイル構成がローカルに得られるはずです

        krewFramework
        ├── krew-framework
        │   └── com
        │       └── tatsuyakoyama
        │           └── krewfw
        │               ├── builtin_actor
        │               ├── core
        │               ├── core_internal
        │               │   └── collision
        │               ├── starling_utility
        │               └── utility
        ├── lib
        └── sample-game
            ├── asset
            │   ├── bmp_font
            │   ├── image
            │   └── image_src
            │       └── game
            ├── core-src
            │   └── krewshoot
            │       ├── actor
            │       │   ├── common
            │       │   ├── game
            │       │   └── title
            │       └── scene
            ├── projects
            │   ├── android-project
            │   ├── ios-project
            │   └── web-project
            └── script
                └── atlas_generator

### swf のビルドと adl での実行

- コマンドラインで krewFramework/sample-game/ 以下に移動し、make します
- make flash で web 向け swf を作成、make run で adl (AIR Debug Launcher) 上で実行します

        $ make flash
        $ make run

### Android 向け apk のパッケージング

- コマンドラインで krewFramework/sample-game/ 以下に移動し、以下を叩きます

        $ make air-android
        $ make android

        # Android 実機を USB で接続し、adb にパスが通った状態で
        $ make install-android

何をやっているかは
[Makefile の中身](https://github.com/tatsuya-koyama/krewFramework/blob/master/sample-game/Makefile)
をご確認ください。


<br/><br/><br/><br/><br>

