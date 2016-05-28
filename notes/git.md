---
title: 'Git Memo'
date: '2014-06-12'
description:
categories: []
tags: [anything, Tips, Git]
position: 6
---

# Git Memo

## Git の中身よく知らない人に説明するなら

- 時間があるなら [Pro Git](https://git-scm.com/book/ja/v2) を読めばそれが全て

____

以下、要約：

- Git は**分散型 VCS** です
    - （SVN とか Perforce はみんなが中央サーバにアクセスする**集中型**）
    - 各自のマシンにリポジトリのクローンが作られる
- リポジトリとは `.git/` があるディレクトリのこと
- 差分の蓄積ではなく**スナップショット**を保存して歴史を管理
    - あらゆるスナップショットやコミットオブジェクトなどにダイジェスト**（SHA-1 ハッシュ）**がついてる

____

- ファイルのとりうる状態
    - Untracked / Unmodified / Modified / Staged
    - (Stash) / Workspace / Stage / Local Repo. / ……… / Remote Repo.

____

- master ブランチは `git init` した時のデフォルトのブランチ名
- origin は `git clone` した時のデフォルトのリモート名
- コミットは、その時の「ルートディレクトリのスナップショット」への参照を持つ
    - コミットは「1 つ前のコミット」（親コミット）への参照を持つ。これにより歴史が辿れる
    - Git のコミットグラフの図では、矢印は 1 つ前のコミットを指している。**時間軸の方向ではない**ので注意
    - マージコミットは複数の親を持つコミット

___

- **ブランチとはコミットを指すポインタ**
    - これが Git の優れた設計ポイント
    - ブランチを作るのはポインタを 1 個作る程度のコストでしかない
    - ブランチを切った時点では歴史は分岐していない。コミットして初めて分岐する
- origin/master は**リモートブランチ**
    - リモートにあるリポジトリ内の master ブランチが、どのコミットを指しているかを意味する
    - `git fetch origin master` すると origin/master がリモートと同じ状態になる

___

- **`git pull` とは、`git fetch` して `git merge` しろという意味**
    - `git fetch origin master` で origin/master が最新になる
    - `git merge origin/master` でローカルブランチの master に
      リモートブランチの origin/master がマージされる

## リファレンス

### よい資料

- [Pro Git](https://git-scm.com/book/ja/v2)
- [こわくない Git](http://www.slideshare.net/kotas/git-15276118)
    - リベースのこととか

### ブランチ運用モデル

- [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
- [GitHub Flow – Scott Chacon](http://scottchacon.com/2011/08/31/github-flow.html)
    - [日本語訳](https://gist.github.com/Gab-km/3705015)
    - [Understanding the GitHub Flow · GitHub Guides](https://guides.github.com/introduction/flow/)

### Tips

- [巨大なリポジトリを Git で上手く扱う方法 - Atlassian Japan](http://japan.blogs.atlassian.com/2014/05/handle-big-repositories-git/)

### コミットメッセージ系

- [GIT Commit Good Practice - OpenStack](https://wiki.openstack.org/wiki/GitCommitMessages)
- [英語コミットコメントに使えるオシャレフレーズ集](http://qiita.com/ken_c_lo/items/4cb49f0fb74e8778804d)
- [git commit時のコメントを英語で書くための最初の一歩](http://www.sssg.org/blogs/hiro345/archives/11721.html)
- [Changelogのための英文テンプレート集](http://d.hatena.ne.jp/pyopyopyo/20070920/p1)
- [ネイティブと働いて分かった英語コミットメッセージの頻出動詞10つ - Qiita](http://qiita.com/gogotanaka/items/b65e1b081fa976e5d754)
- [Git - 英語のコメントや issue で頻出する略語の意味 (FYI, AFAIK, ...) - Qiita](http://qiita.com/uasi/items/86c3a09d17792ab62dfe)
- [commit-m: GitHubコミットメッセージの文例が検索できるサービス](http://commit-m.minamijoyo.com/commits/search?keyword=fix+bug)

### プルリク開発

業務の開発も OSS 開発のように行おう

- [空コミット便利！git commit --allow-emptyでgitを使った開発フローを改善 - fukajun - DeepValley -](http://fukajun.org/25)
- [git commit --allow-empty を使った WIP PR ワークフロー - Qiita](http://qiita.com/a-suenami/items/129e09f8550f31e4c2da)
- [github を用いた開発フロー テンプレート](http://pepabo.github.io/docs/github/workflow.html)
- [WIPブランチをPull Requestする運用をためした - 15 min/d](http://bouzuya.hatenablog.com/entry/2014/04/02/235959)
- [Yakst - より良いプルリクエストのための10のヒント](http://yakst.com/ja/posts/1625)
- [ピクセルグリッドの仕事術 技術編 - コードレビューのフロー | CodeGrid](https://app.codegrid.net/entry/code-review)
    - こちらはレビュー待ちを無くすためにすぐ merge して後からレビュー、というやり方

## よくやる

### pull --rebase

コミット後・push 前にリモートから差分取得する時にマージコミットができるとログが見づらくなる、
という理由で merge の代わりに rebase をする以下のオプションがよく使われる：

    git pull --rebase origin master

> ※ リベースを理解してない人がやると、コンフリクト時に死ぬ

### checkout -b

    # ブランチを作ってそこに移動
    git checkout -b new_branch

    # ↑ は以下のコマンドのショートカット
    git branch new_branch
    git checkout new_branch

<br/><br/>
## git log

### ログから対象文字列を含むコミットを検索

    # --since は "2 days" みたいに柔軟な指定ができる
    git log -S "target_word" --since="1 week"

<br/><br/>
## git branch

### ブランチを消す

    git branch -d branch_name     # ローカルのを消す
    git push origin :branch_name  # リモートのを消す

【補足】

> `git push origin master` は<br/>
> `git push origin master:master`
> の略。
>
> ローカルブランチの `master` をリモートブランチの `master` に push するという意味。
>
> 上記の消すやつは空 branch を push してる感じ

### 作成者を含めてブランチ一覧表示

    git for-each-ref --format='%(authorname) %09 %(refname)' | grep 'refs/remotes/origin' | sort -k5n -k2M -k3n -k4n

### 消されたブランチを手元でも消す
誰かがリモートブランチを削除しても、ローカルでは残っている。
以下のコマンドでそれを整理できる

    git remote prune origin

<br/><br/>
## git diff

### git diff で作ったパッチを当てる

    git diff > patch.txt
    patch -p1 < patch.txt

<br/><br/>
## git tag

    # 一覧
    git tag

    # タグを打つ
    git tag v1.0.0

    # 特定コミットにタグを打つ
    git tag v1.0.0 <commit_hash>

    # リモートにタグ全部 push
    git push origin --tags

    # ログ見るとき、%d でタグ情報も表示できるよ
    git log --pretty=format:"%C(yellow)%h%C(reset) %C(blue)%ad %C(reset)%C(red)%an%C(reset) - %s %C(green)%d%C(reset)" --graph --date-order -30 --date=iso


<br/><br/>
## プルリクの差分を手元で見る

でかい差分とか GitHub だと truncate されちゃうので

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

## Untracked files を一瞬で消し去る

    git clean -fdx

    # n をつけると dry-run
    git clean -fdxn

## ^M とかを無視する

    git config --global core.whitespace cr-at-eol




