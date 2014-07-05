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


<br/><br/><br/>

