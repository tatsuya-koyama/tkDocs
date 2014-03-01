---
title: 'ゲーム開発を始めよう'
date: '2014-02-23'
description:
categories: []
tags: [anything, krewFramework]
position: 4
---

# さあ、ゲーム開発を始めよう

## krew-skeleton でプロジェクトのひな形の生成

krewFramework を使ったゲームのコードを書き始める際の、
プロジェクトのひな形を生成するためのスクリプトを用意しています。

<a href="https://github.com/tatsuya-koyama/krew-skeleton"
   class="btn large-btn" style="margin: 0.5em 1.0em;">
  <img class="btn-icon" src="{{urls.media}}/krewfw/GitHub-Mark-64px.png" width="28" height="28" />
  GitHub | krew-skeleton
</a>

krew-skeleton を用いることで、 1 つのコンフィグファイルから
複数プラットフォーム向けの FlashBuilder プロジェクトと、足がかりとなるソースコード・アセットを
対象のディレクトリにコマンド一発で生成できます。


## 新しいゲームを書き始める手順

FlashBuilder またはコマンドラインで AIR アプリがビルドできる環境が整っている前提で話を進めます。
まだ整っていない場合は以下を参照してください。

- [AIR SDK のセットアップとサンプルのビルド](/krew-framework/instllation)

### 準備： krew-skeleton の clone

- krew-skeleton のコードをローカルに clone しておきます

        $ git clone git@github.com:tatsuya-koyama/krew-skeleton.git

### 1. 新しいゲーム用の git リポジトリを作る

- 中身は空でよいです
- GitHub 上でリポジトリを作り、それをローカルに clone するのが手軽でしょう
- ここでは仮にリポジトリ名を `FirstKrewGame`,
  ローカルに clone したパスを `~/path/to/FirstKrewGame/` であるとします

### 2. krew-skeleton/setup.cfg を編集

- `setup.cfg` は以下のようなテキストファイルです
- これの = の右辺を、あなたが作りたいゲームに合わせて編集します

        [names]
        app_id               = com.your-domain.game-title
        as3_package_name     = your_package
        app_title            = AppTitle
        app_filename         = AppTitle_forShort
        swf_filename         = swf_output_name_for_web_publishing.swf
        
        fb_path_var          = PATH_VAR_NAME_FOR_FLASH_BUILDER
        fb_debug_proj_name   = apptitle-debug-project
        fb_android_proj_name = apptitle-android-project
        fb_ios_proj_name     = apptitle-ios-project
        fb_web_proj_name     = apptitle-web-project
        
        [info]
        app_version = 1.0
        description = Your App Description.
        publisher   = Your Name
        creator     = Your Name
        language    = EN
        
        [attributes]
        default_bg_color = 0x000000
        default_fps      = 60
        auto_orients     = true
        
        # landscape or portrait
        aspect_ratio     = landscape
        
        [env]
        air_sdk_ver = 4.0

___

- `fb_path_var` は FlashBuilder で使用するパス変数名です
    - ここで指定した変数名にゲームのリポジトリまでのパスを指定すると、
      FlashBuilder 上でのパスが通るようになります

### 3. krew-skeleton の実行

- 以下のコマンドに、対象となるリポジトリのパスを渡して実行します
- （Python が動作する環境が必要です。 Mac であれば問題ないでしょう）

        $ ./setup.py -o ~/path/to/FirstKrewGame/

- これで完了です。`setup.py` はデフォルトでコンフィグファイルに `setup.cfg` を用いますが、
  別のファイル名で作った場合はオプションで指定することもできます

        $ ./setup.py -o ~/path/to/FirstKrewGame/ -c mysetup.cfg

#### krew-skeleton がやっていること

画面に実行したコマンドが出力されるのでそれが全てですが、概ね以下のようなことをやっているだけです。

- `TEMPLATES/` 以下のファイルを対象ディレクトリにコピー
- `TEMPLATES/` 内の識別子を `setup.cfg` で定義した値に置換（`grep | xargs sed` してるだけ）
- `.gitignore` を対象ディレクトリにコピー
- `SAMPLE_ASSETS/` 以下のファイルを対象ディレクトリにコピー
- krewFramework を `git submodule add` する


## ビルドしてみる

生成した skeleton のコードをビルド・実行してみましょう

### コマンドラインでビルド

生成されたコードにある `~/path/to/FirstKrewGame/commandline-build/` 以下に入り、以下を実行します

    $ make debug  # swf をビルド
    $ make run    # adl で実行

問題が無ければ、シンプルなデモが実行されます。

### FlashBuilder でビルド

- まずあなたのリポジトリが clone されている場所を FlashBuilder のワークスペースレベルに設定する必要があります
    - Flash Builder → 環境設定 → 一般 → ワークスペース → リンクされたリソース
    - **ここに `setup.cfg` の `fb_path_var` で指定した名前でパス変数を作り、**
      `~/path/to/FirstKrewGame` のパスを設定します

___

- 左側にあるペーンのパッケージエクスプローラで右クリック → インポート
    - 既存プロジェクトをワークスペースへ
    - `~/path/to/FirstKrewGame/projects/debug-project` などを指定

___

- プロジェクトを実行 or デバッグ


## あなたのゲームを作る

踏み出すための足場は出来上がりました。さあ、あなたのゲームを作りましょう。

> 【Note】 krew-skeleton が生成する `core-src/` や `assets/` 以下のファイルは
> 足がかりとなるサンプルです。必要に応じて削除・編集してください。

<br/><br/>

