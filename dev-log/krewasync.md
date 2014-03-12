---
title: 'KrewAsync 設計メモ'
date: '2014-03-06'
description:
categories: []
tags: [anything, krewFramework]
position: 12
---

# KrewAsync 設計メモ

## KrewAsync っての作った

- [解説ページ（デモ + ソースあり）](/krew-framework/samples/krewasync)

割といい感じに設計・実装できたのでメモ。

コード部分は 200 行くらいでピュア AS3 のクラス 1 個だし、
テストもドキュメントもしっかり書いたし。


## やる前に調べた

- JSDeferred をはじめ、JS / AS3 の Deferred 系の既存ライブラリ調べた
- 参考リンク
    - [（V8で）Promiseが実装された](http://js-next.hatenablog.com/entry/2013/11/28/093230)
    - [GitHub | ASDeferred](https://github.com/minodisk/asdeferred)
    - [Promises Promises (AS3 blog)](http://blog.onebyonedesign.com/actionscript/promises-promises/)
    - [GitHub | caolan / async](https://github.com/caolan/async)


## 要件

- メソッドチェーンじゃなくていい。JSON 書いてやりたい
- Deferred / Promise は初心者には若干とっつきにくいだろう。パッと見の分かりやすさ大事
- 「どの部分も、JSON 書いてもいいし、クラスオブジェクトに置き換えてもいい」みたいな構造にしたかった

## 構造

こういうふうに使う

    var async:KrewAsync = new KrewAsync( {asyncDef} );
    async.go();

ここで、`{asyncDef}` の定義がキモになる。
「クラスオブジェクトも指定できる」が今回 must の要件。
ってことには、究極的にはこう？

    {asyncDef} ::= <KrewAsync>

つまり、**KrewAsync はコンストラクタの引数に KrewAsync 自体を受け取って、**
**その内容をコピーすることで自分自身をつくる。** 超再帰的。かっちょいい。
じゃあその KrewAsync はどうつくるの？

そこで、中身を定義する Object を渡してもいいことにする

    {asyncDef} ::= <KrewAsync> ||
    {
        // 以下 3 つのうちいずれかを指定
        single  : function(async:KrewAsync):void {},
        serial  : [{asyncDef}, ... ],
        parallel: [{asyncDef}, ... ],

        error : function():void {}   // optional
        anyway: function():void {}   // optional
    }
    // Object だったら、この情報をもとに作った KrewAsync インスタンスに置き換える。
    // これで最初の定義を満たす形になった

この JSON の中の serial と parallel の配列の要素にも、{asyncDef} が指定可能。
末端の子ノードは single に指定された Function を実行することにする。

ここで、Function を指定したときは以下に置換する決まりを作る。
これによって、{asyncDef} のところにただの Function を並べることが可能になる。

    // {asyncDef} が Function だったら以下に置き換え
    {
        single: Function
    }

あと Array が余ってるので、これも置換ルールを設定しておく

    // {asyncDef} が Array だったら以下に置き換え
    {
        serial: Array
    }

これで {asyncDef} の部分は、

- KrewAsync そのもののインスタンス
- 中身を記述する Object
- 末端ノードのタスクを意味する Function
- serial のショートカットになる Array

どれを指定してもよいという柔軟なインタフェースになった。
めでたし。



