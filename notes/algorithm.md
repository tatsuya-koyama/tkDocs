---
title: 'Algorithm'
date: '2014-01-16'
description:
categories: []
tags: [anything, Programming, Algorithm]
position: 2
---

# Algorithm

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



<br/><br/><br/><br/><br/><br/><br/><br/>

