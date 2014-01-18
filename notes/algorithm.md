---
title: 'Algorithm'
date: '2014-01-16'
description:
categories: []
tags: [anything, Programming, Algorithm]
position: 2
---

# About tkNotes

## リーズナブルな配列のシャッフル Fisher–Yates shuffle

最初に末尾と入れ替えて、範囲を 1 ずつ小さくしてく

- [Wikipedia - Fisher–Yates shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
- [配列を少ない仕事量でシャッフルするFisher-Yates法](http://blog.svartalfheim.jp/?p=273)

        var i:int = array.length;
        var j:int;
        var tmp:Object;

        while (i) {
            j   = Math.floor(Math.random() * i);
            tmp = array[--i];
            array[i] = array[j];
            array[j] = tmp;
        }


<br/><br/><br/><br/><br/><br/><br/><br/>

