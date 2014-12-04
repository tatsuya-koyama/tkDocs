---
title: 'Git Memo'
date: '2014-06-12'
description:
categories: []
tags: [anything, Tips, Git]
position: 6
---

# Git Memo

## コミットメッセージ系

- [GIT Commit Good Practice - OpenStack](https://wiki.openstack.org/wiki/GitCommitMessages)
- [英語コミットコメントに使えるオシャレフレーズ集](http://qiita.com/ken_c_lo/items/4cb49f0fb74e8778804d)
- [git commit時のコメントを英語で書くための最初の一歩](http://www.sssg.org/blogs/hiro345/archives/11721.html)
- [Changelogのための英文テンプレート集](http://d.hatena.ne.jp/pyopyopyo/20070920/p1)


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



<br/><br/><br/>

