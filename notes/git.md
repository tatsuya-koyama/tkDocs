---
title: 'Git Memo'
date: '2014-06-12'
description:
categories: []
tags: [anything, Tips, Git]
position: 6
---

# Git Memo

## Tips

- [巨大なリポジトリを Git で上手く扱う方法 - Atlassian Japan](http://japan.blogs.atlassian.com/2014/05/handle-big-repositories-git/)

## コミットメッセージ系

- [GIT Commit Good Practice - OpenStack](https://wiki.openstack.org/wiki/GitCommitMessages)
- [英語コミットコメントに使えるオシャレフレーズ集](http://qiita.com/ken_c_lo/items/4cb49f0fb74e8778804d)
- [git commit時のコメントを英語で書くための最初の一歩](http://www.sssg.org/blogs/hiro345/archives/11721.html)
- [Changelogのための英文テンプレート集](http://d.hatena.ne.jp/pyopyopyo/20070920/p1)
- [ネイティブと働いて分かった英語コミットメッセージの頻出動詞10つ - Qiita](http://qiita.com/gogotanaka/items/b65e1b081fa976e5d754)
- [Git - 英語のコメントや issue で頻出する略語の意味 (FYI, AFAIK, ...) - Qiita](http://qiita.com/uasi/items/86c3a09d17792ab62dfe)
- [commit-m: GitHubコミットメッセージの文例が検索できるサービス](http://commit-m.minamijoyo.com/commits/search?keyword=fix+bug)

## プルリク開発

業務の開発も OSS 開発のように行おう

- [空コミット便利！git commit --allow-emptyでgitを使った開発フローを改善 - fukajun - DeepValley -](http://fukajun.org/25)
- [git commit --allow-empty を使った WIP PR ワークフロー - Qiita](http://qiita.com/a-suenami/items/129e09f8550f31e4c2da)
- [github を用いた開発フロー テンプレート](http://pepabo.github.io/docs/github/workflow.html)
- [WIPブランチをPull Requestする運用をためした - 15 min/d](http://bouzuya.hatenablog.com/entry/2014/04/02/235959)
- [Yakst - より良いプルリクエストのための10のヒント](http://yakst.com/ja/posts/1625)
- [ピクセルグリッドの仕事術 技術編 - コードレビューのフロー | CodeGrid](https://app.codegrid.net/entry/code-review)
    - こちらはレビュー待ちを無くすためにすぐ merge して後からレビュー、というやり方

### プルリクの差分を手元で見る

でかい差分とか GitHub だと truncate されちゃうからね

    # feature -> master のプルリクの差分を見たいとき
    # （トリプルドットを使う）
    git diff master...feature

    # 僕は周辺行を多く表示するのが好き（コンテキストを理解しやすい）
    # （-U<行数> オプションを使う。grep の -C みたいなもの）
    git diff master...feature -U30

- 参考
    - [Atlassian Japan | さらに優れたプルリクエスト](http://japan.blogs.atlassian.com/2015/02/a-better-pull-request/)
    - [Git - リビジョンの選択](http://git-scm.com/book/ja/v1/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E3%83%AA%E3%83%93%E3%82%B8%E3%83%A7%E3%83%B3%E3%81%AE%E9%81%B8%E6%8A%9E)

## .gitignore に足したんだけどもうそれ add しちゃってたとき

- すでに add されてるファイルはキャッシュ残ってて .gitignore 効かない
- 再反映する

        git rm -r --cached .
        git add .
        git commit -m "Reapply .gitignore"
        git push origin master

> 参考：[.gitignore の設定を反映させる](http://qiita.com/Potof_/items/c75eba9cfa72819506de)


## うっかり commit しちゃったファイルを git の履歴からも消す

- ここに書いてある方法でいけた
    - [gitで特定のファイルの履歴を消す方法](http://d.hatena.ne.jp/ichhi/20110825/1314300975)


## あのファイル消えてるけどどこで消えちゃったんだろう

- オブジェクトの歴史を辿る `git rev-list` というコマンドがある
    - [Git - git-rev-list Documentation](https://git-scm.com/docs/git-rev-list)
    - [gitで削除してしまったファイルの復元 - itochin2の日記（仮）](http://itochin2.hatenablog.com/entry/2013/06/06/020939)
- 指定したポイントから時系列逆順に commit の歴史を表示してくれる
- 以下のように打てば消えたファイルについても履歴が見れる

```
git rev-list --pretty HEAD -- 対象のファイルパス
# 最後の commit だけ表示したいなら -n 1 を与えればよい
```


## git tag

- 一覧

        git tag

___

- タグを打つ

        git tag v1.0.0

___

- 特定コミットにタグを打つ

        git tag v1.0.0 <commit_hash>

___

- リモートにタグ全部 push

        git push origin --tags

___

- ログ見るとき、`%d` でタグ情報も表示できるよ

        git log --pretty=format:"%C(yellow)%h%C(reset) %C(blue)%ad %C(reset)%C(red)%an%C(reset) - %s %C(green)%d%C(reset)" --graph --date-order -30 --date=iso


## git branch

- ブランチ消す

        git branch -d branch_name     # ローカルのを消す
        git push origin :branch_name  # リモートのを消す

【補足】

    git push origin master
    は
    git push origin master:master
    の略。

    ローカルブランチの master をリモートブランチの master に push するという意味。



<br/><br/><br/>

