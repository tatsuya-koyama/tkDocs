---
title: 'ゲームのチーム開発フロー'
date: '2013-12-06'
description:
categories: []
tags: [anything, Game-Development]
position: 7
---

# ゲームのチーム開発の開発フローについて考える

## バージョン管理

### GitHub Flow

- [GitHub Flow – Scott Chacon](http://scottchacon.com/2011/08/31/github-flow.html)
    - [日本語訳](https://gist.github.com/Gab-km/3705015)

### Git のブランチ運用

- 何だかんだ鉄板： [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)


### ワークファイル

- 小規模の開発なら、ゲームに使う実データのための作業ファイルも Git 入れとくのは楽
    - スプライトシート化の前の画像はまあ入れるだろうけど
    - PhotoShop の psd とか、タイルマップの tmx とか
    - 他の人が見れるようにしておくと作業・職種の障壁減る
    - ファイルサイズが気にならないレベルであればね
    - ただ、ディレクトリは asset/workfile/ みたいに分けておいてアプリのパッケージに入らないようにね
___

- データが大きくなるなら別の場所に保管するとか考える
    - でも作業ファイルのアップロード忘れとかあって、他のアーティストがいじるときに困るとかよくある

### サーバとクライアント双方のバージョン管理

- ToDo: まとめる
- プロジェクトがリリースされてから更新されてく系だと、ここらへんの管理が少々煩雑


## 準備しておくとよいもの

- シソーラス
    - ゲーム中のシステムのシソーラス
    - ゲーム中のキャラの喋り方などのシソーラス
- （書き途中…）


## 非エンジニアのデータ調整のイテレーション

まず、もろもろのアセットやレベルデータがきちんとデータ駆動になっている
（ファイルを変えれば挙動が変えられる状態である）前提とする。
エンジニアはまあ手元でローカルのファイルをちょこちょこいじればすぐに変更の反映を確認できる。
問題は実装環境を持たないアーティストやゲームデザイナーが、どうイテレーションを回すか。

### 要件

> - ゲームのアプリケーションを再起動せずに、  
>   見た目やパラメータだけ変えて実機での挙動を確認したい

### 実機クライアントがサーバのデータを見る

- デバッグ時はローカルにあるファイルでなく、開発サーバにあるデータを見に行くようにスイッチする
    - アーティストは開発サーバ上のデータを置き換える
    - Adobe AIR なら URLLoader を使ってやればこのへんの制御はカンタン
- 実現が簡単
- まあちょっとしたものならこれが妥当な手段
- ローカルファイルのアクセスがウェブの通信に切り替わるので、 Loading に時間がかかるのが欠点

### 実機をサーバにして PC からデータを飛ばす

- 逆のアプローチもある。
- 実機がリクエスト受け付けて、PC からデータをアップロードできるようにする
    - あらかじめ実機側で tcp ソケットで listen するか、 HTTP サーバなどを立てておく
    - データファイルやらコマンドやらを送って、実機アプリのそれを置き換えられる仕組みをつくる
    - iOS などのアプリにバンドルされたものは置き換えられないので、
      データ領域に保存してあればそちらを見に行くように
- PC 側にデバッグメニューを持って行ける、複数人が並行で作業しやすい、などの利点がある


## 非エンジニアがバージョン管理されているデータをどう更新するか

- アーティストも Git を使う
    - システム的な観点で見ると、もっとも素直なソリューション
    - GUI のあるソフト使えばいくぶんかマシになる
    - 【Pros】
        - 普通のバージョン管理の開発になる
    - 【Cons】
        - 非エンジニアが Git 覚えることの学習コストがある
        - Git は結構ミスりやすい

___

- 開発サーバ上で変更・確認して反映はシステム使ってガッとやる
    - 深夜に自動でマージされますとか、CI ツールのボタン一発で反映できますとか
    - 【Pros】
        - Git 覚えなくていい。Git 操作によるミスがなくなる
    - 【Cons】
        - 環境構築に一手間かかる
        - コンフリクトは起きるのでそこはエンジニアが解決してやる必要がある
        - そうは言ってもバージョン管理の大枠を理解していないと事故が起きうる

