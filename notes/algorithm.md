---
title: 'Algorithm'
date: '2014-01-16'
description:
categories: []
tags: [anything, Programming, Algorithm]
position: 2
---

# Algorithm

## ソート関連

- [Wikipedia - クイックソート](http://ja.wikipedia.org/wiki/%E3%82%AF%E3%82%A4%E3%83%83%E3%82%AF%E3%82%BD%E3%83%BC%E3%83%88)
- [404 Blog Not Found: bucket sort - 比較しなければソートは相当速い](http://blog.livedoor.jp/dankogai/archives/51764496.html)
- [Wikipedia - スリープソート](http://ja.wikipedia.org/wiki/%E3%82%B9%E3%83%AA%E3%83%BC%E3%83%97%E3%82%BD%E3%83%BC%E3%83%88#.E3.82.B9.E3.83.AA.E3.83.BC.E3.83.97.E3.82.BD.E3.83.BC.E3.83.88)
    - 「バケットソートのバケツをメモリ空間の代わりに時間に置き換えたもの」…なるほど。


## 乱数系

- [Wikipedia - 線形合同法](http://ja.wikipedia.org/wiki/%E7%B7%9A%E5%BD%A2%E5%90%88%E5%90%8C%E6%B3%95)
- [Wikipedia - メルセンヌツイスタ](http://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%AB%E3%82%BB%E3%83%B3%E3%83%8C%E3%83%BB%E3%83%84%E3%82%A4%E3%82%B9%E3%82%BF)
- [Wikipedia - Xorshift](http://ja.wikipedia.org/wiki/Xorshift)

___

- [遠藤雅伸公式blog - 100分の1を100回やってみる](http://ameblo.jp/evezoo/entry-10704872133.html)
    - 100 分の 1 を 100 回やって、1 回は当たってる確率は 63 ％くらい


## 自動生成系

- [古くて新しい自動迷路生成アルゴリズム](http://getnews.jp/archives/288113)
    - ドルアーガの塔の迷路生成とか


## リーズナブルな配列のシャッフル Fisher–Yates shuffle

最初に末尾と入れ替えて、範囲を 1 ずつ小さくしてく

- [Wikipedia - Fisher–Yates shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
- [配列を少ない仕事量でシャッフルするFisher-Yates法](http://blog.svartalfheim.jp/?p=273)

        // ActionScript 3.0
        var i:int = array.length;
        var j:int;
        var tmp:Object;

        while (i) {
            j   = Math.floor(Math.random() * i);
            tmp = array[--i];
            array[i] = array[j];
            array[j] = tmp;
        }

- underscore.js の実装とかオシャレ

        _.shuffle = function(obj) {
          var rand;
          var index = 0;
          var shuffled = [];
          each(obj, function(value) {
            rand = _.random(index++);
            shuffled[index - 1] = shuffled[rand];
            shuffled[rand] = value;
          });
          return shuffled;
        };


## catmull-rom spline

- 指定した点通ってくれるやつ
- [catmull-rom spline](https://www.google.co.jp/search?q=catmull-rom+spline&rls=en&source=lnms&tbm=isch&sa=X&ei=ux7hUt-xIcKAkQX-zYHwBw&ved=0CAcQ_AUoAQ&biw=1569&bih=1027)


## いもす法

- 累積和をアルゴリズムを多次元、多次数に拡張したもの
- 愚直な方法よりも計算量を抑える（次元の上昇に強い）
    - [いもす法](http://imoz.jp/algorithms/imos_method.html)


<br/><br/><br/>

