---
title: 'この tkDocs をどう作ったか'
date: '2013-12-08'
description:
categories: []
tags: [anything, ruhoh]
position: 2
---

# この tkDocs をどう作ったか

## なぜ tkDocs を作ったか

以下を満たすものが必要だった

- 勉強したことや技術情報をウェブ上にまとめておく場所
- 自分が作ったもののドキュメンテーションを公開する場所
- それを行いやすい環境

自分のサイトだったり、プライベートな wiki だったりは持っていたが
いまいちしっくり来なかったので新しく用意することにした。

## tkDocs の要件は何だったか

- CMS を用いるのではなく、ジェネレータで静的なコンテンツを生成して公開したい
    - サーバの負荷が下げられる
    - 静的なら、コンテンツのバージョン管理や移動が楽になる
    - Web 上のエディタでなく、慣れ親しんだ Emacs で書きたい

___

- Markdown で記述したい
    - 書くのができるだけ楽なものがよい
    - 他の人も実践できるように、より大衆的な形式を採用したい
    - ソースファイルを GitHub で管理した際に、ブラウザ上で読みやすい

___

- 書く人は自分だけ、もしくは限られたメンバーだけでよい
    - Wiki のようなオープンなものでなくてよい
    - 構造をきちんと規定して作っていく方が重要

## どういうソリューションを選んだか


- サイトジェネレータに [ruhoh](http://ruhoh.com/)
    - 有名どころの Sphinx なども考えたが、Markdown が書けるところや
      コンパクトさからこちらを選んだ
    - 色々探した中で ruhoh 自身のドキュメンテーションが綺麗で見やすかったので気に入った

___


- Markdown のソースは [GitHub](https://github.com/tatsuya-koyama/tkDocs) で管理
    - Markdown を整形してくれるので GitHub 上でも見やすい
    - 例えばこのページのソースは [こんな感じ](https://github.com/tatsuya-koyama/tkDocs/blob/master/dev-log/how-to-make-tkdocs.md)

___

- デザインは適当にパクりつつ自分で CSS 書いて整える
    - レスポンシブ対応は [Twitter Bootstrap](http://getbootstrap.com/2.3.2/) に頼る


## セットアップ手順

- 公式のドキュメントで概ね問題なかったと思う
- 日本語でよくまとまってた記事は [ここ](http://www.gcnote.jp/note/tool-ruhoh/) とか

### Ruby 2.0 のインストール

- Mac デフォルトの ruby のままだったので 1.8 くらいだった
- rvm (Ruby Version Manager) をインストール

        curl -L get.rvm.io | bash -s stable

- パスを通す。僕の場合は ~/.bashrc に以下を追記して source ~/.bashrc した

        [ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm

- rvm を最新にして、ruby 2.0 をインストール

        rvm get head
        rvm get latest
        rvm install 2.0.0

- ruby -v でそれらしい結果が出れば完了

### ruhoh のインストール

- [公式](http://ruhoh.com/docs/2/) のドキュメントを参考に
- GitHub あさってたら見つけた [blog 用の公式ひな形](https://github.com/ruhoh/blog)
  を clone して、それを足がかりに始めるのが無難
- リポジトリにしたいディレクトリに、以下の内容の Gemfile つくる

        source "https://rubygems.org"
        gem 'psych', "~> 1.3"
        gem 'ruhoh', "~> 2.1"

- Gemfile と同じ階層で以下のコマンドを叩く

        bundle install

- 以下を叩いてプレビュー用のサーバが立ち上がれば成功
    - http://localhost:9292 にアクセスすると Markdown のソースとテンプレートによる整形結果が確認できる

            bundle exec ruhoh server 9292

## ruhoh の概要

- pages とか essay とか my-documents とか大枠ごとにディレクトリ切って、
  そのディレクトリ名で essay.all みたいに扱う感じ
    - ruhoh ではこれらを Collection と呼んでいる
    - Collection ごとにスコープになっていて、pages のページ一覧とかは出せるけど、
      pages と essay をまたいだカテゴリ一覧みたいなのは出せない

___

- テーマのディレクトリにレイアウトのテンプレートとなる html を置く
    - essay のテンプレートだったら my-theme/layout/essay.html という名前で置く決まり
    - テンプレート構文は [mustache](http://mustache.github.io/)


## 独自にやったこと

- テンプレート（サイトのレイアウト）は自分で html とか css を書いた
    - ３カラムの css は ruhoh 公式サイトのドキュメントのそれを参考にさせてもらった
    - レスポンシブ対応してる（ウインドウ狭くするとカラム閉じる、スマフォでもそれなりに見れる）

___

- ２列目のインデックス（Table of Contents）も ruhoh ドキュメントのものを拝借して少しいじった
    - JavaScript で頑張ってページ表示後に生成してるだけ
    - ここまでジェネレートの時点でやれればよかったが…


## ドキュメンテーションのフロー

- 以下のような Makefile を書いておく

        deploy:
            ruhoh compile
            rsync compiled/. \
                  -e "ssh -o GSSAPIAuthentication=no" \
                  -avz --delete \
                  --exclude .git \
                  user@host:/path/to/docs
        
        http-server:
            ruhoh compile
            pushd compiled; python -m SimpleHTTPServer 8000; popd
        
        ruhoh-server:
            bundle exec ruhoh server 9292

- （rsync の ssh オプションはなんか僕のサーバの ssh の設定いじってもうまく反映されなかったので
    直接書いてるだけ。気にしないで）

### Markdown のプレビュー

- 上記 Makefile で make ruhoh-server しておけば、ブラウザで http://localhost:9292 で表示確認できる
    - Markdown や CSS, ページ構造に変更があると反映してくれる
    - プラグインとかその辺書き換えた時はサーバ立ち上げ直さないとダメ
    - 【ToDo】オートリロードの仕組みがあるとより楽

___

- 静的ファイルを compile してそれを http サーバで確認したいときは
  上記 make http-server してから http://localhost:8000 にアクセス
    - python の SimpleHTTPServer は便利だね
    - まあプレビューは ruhoh server で事足りると思う

### デプロイ

- デプロイは上記 make deploy
    - 男らしく指定のサーバへ一発 rsync だ！

### コードのバージョン管理

- 今は単純に GitHub に上げておいて、デプロイタイミングなどで手で git commit & git push してるだけ
    - 静的サイトは git push にフックしてデプロイ、みたいなのがモダンだけど、面倒なのでやってない
    - デプロイ先のサーバに Git のリポジトリも置くならすぐできるけどね


<br/><br/><br/>

