---
title: 'バグあるある'
date: '2014-07-01'
description:
categories: []
tags: [anything, Programming, Debug]
position: 10
---

# バグあるあるノート

## [AS3] ループの前の値引きずってるパターン

人の書いたコードでこんな感じのあった（実際はもう少し複雑）：

    /** 型などは省略 */

    // レベルごとの情報をまとめて表示したい
    var levelDetailList;

    for each (var level in levelRecords) {
        var reward;
        // レベルをまだクリアしていない時、初回クリアリワードがもらえる
        if (level.isCleared) {
            reward = level.firstReward;
        }
        else {
            // 2 回目以降のリワード。リワードが無い場合もある
            if (level.hasRegularReward) {
                reward = level.regularReward;
            }
        }

        // リワードがあったなら、それを表示情報に登録しよう
        var levelDetail;
        if (reward) {
            levelDetail.registerReward(reward);
        }

        levelDetailList.add(levelDetail);
    }

ここで reward が初期化されていないと、AS3 では前回ループの値が保持されてしまうようだ。
AS3 は JS と似ていて、ブロックレベルの変数スコープはない。（function か class のスコープになる。）
C++ や Java のように { } がスコープになるわけではないので注意。
ちなみに AS3 に JS の hoisting（変数の巻き上げ）のような挙動はない。

### 解決策

`var reward;` を `var reward = null;` とすればよい。
だが個人的には以下のように function スコープに切ってしまう方が、読みやすさとしても安全性としてもよいと思う。
以下のコードは先のものと同じことをしているが、読むときに思考のスタックをあまり使わなくて済む。

    private function _someFunc() {
        ...
        // レベルごとの情報をまとめて表示したい
        var levelDetailList;

        for each (var level in levelRecords) {
            var levelDetail = _makeLevelDetail(level);
            levelDetailList.add(levelDetail);
        }
    }

    private function _makeLevelDetail(level) {
        // リワードがあったなら、それを表示情報に登録しよう
        var levelDetail;
        var reward = _getReward(level);
        if (reward) {
            levelDetail.registerReward(reward);
        }

        return levelDetail;
    }

    private function _getReward(level) {
        // レベルをまだクリアしていない時、初回クリアリワードがもらえる
        if (level.isCleared) {
            return reward;
        }
        // 2 回目以降のリワード
        if (level.hasRegularReward) {
            return level.regularReward;
        }
        // リワードが無い場合もある
        return null;
    }

### 参考コード

例えば以下の AS3 のコード

    for (var i:int = 0;  i <= 5;  ++i) {
        var a:int;
        if (i % 2 == 0) { a = i; }
        trace(a);
    }

は `0 0 2 2 4 4` を出力する。`var a:int = -1` のように初期化しておくと、
`0 -1 2 -1 4 -1` という出力になる。


<br/><br/><br/><br/>

