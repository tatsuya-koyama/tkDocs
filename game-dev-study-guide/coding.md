---
title: '04.コーディング'
date: '2015-08-16'
description:
categories: []
tags: [anything, GameDevStudyGuide]
position: 4
---

# 4. コーディング
<p class="created-at">Updated at: 2015-08-16</p>

## 良いコードとは何か

例えば以下のような 2 つの疑似コードがある。
両者は本質的に同じようなことをやっているのだが、見た目は大きく異なる。

```
// 初心者っぽいコード
void update() {
    if ((myFirst > otherFirst && myFirst < otherLast) &&
        (myLast > otherFirst && myLast < otherLast) &&
        (myFirst < otherFirst && myLast > otherLast))
    {
        // 重なった時の込み入った処理
        // ...
        // ...
    }
}
```

____

```
// 慣れている人っぽいコード
bool Range::isOverlappedWith(Range other) {
    if (other.last < first) { return false; }
    if (first < other.last) { return false; }
    return true;
}

void _onOverlap() {
    // 重なった時の込み入った処理
    // ...
    // ...
}

void update() {
    if (myRange.isOverlappedWith(otherRange)) {
        _onOverlap();
    }
}
```

おそらく多くの職業プログラマが、後者の方がより慣れたプログラマが書いたものだと判断するだろう。
そして後者の方が読みやすく、保守性が高いコードだと言うだろう。

2 つのコードは何が違うんだろう？
少なくとも、要求を満たすように動く以上の良し悪しが、コードの書き方にはあるのだ。

## 参考文献

### リーダブルコード

<div class="azlink-box"><div class="azlink-image" style="float:left"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873115655/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51MgH8Jmr3L._SL160_.jpg" alt="リーダブルコード ―より良いコードを書くためのシンプルで実践的なテクニック (Theory in practice)" style="border:none" /></a></div><div class="azlink-info" style="float:left;margin-left:15px;line-height:120%"><div class="azlink-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873115655/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank">リーダブルコード ―より良いコードを書くためのシンプルで実践的なテクニック (Theory in practice)</a><div class="azlink-powered-date" style="font-size:7pt;margin-top:5px;font-family:verdana;line-height:120%">posted at 2015.8.17</div></div><div class="azlink-detail">Dustin Boswell,Trevor Foucher,須藤 功平,角 征典<br />オライリージャパン<br /></div><div class="azlink-link" style="margin-top:5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4873115655/tkoreshiki-22/ref=nosim/" target="_blank">Amazon.co.jp で詳細を見る</a></div></div><div class="azlink-footer" style="clear:left"></div></div>

いきなり言ってしまうと、2015 年の現在においては、最初にこれを読んでおけば間違いない。
変数名や関数名のつけ方、コメントにどういうことを書くべきか、といった基本的なことから
スコープを小さくしてシンプルさを保つといったところまで、読みやすい文体で小さくまとめられている。

### ゲームプログラマのためのコーディング技術

<div class="azlink-box"><div class="azlink-image" style="float:left"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774174130/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank"><img src="http://ecx.images-amazon.com/images/I/51mo2vCXHfL._SL160_.jpg" alt="ゲームプログラマのためのコーディング技術" style="border:none" /></a></div><div class="azlink-info" style="float:left;margin-left:15px;line-height:120%"><div class="azlink-name" style="margin-bottom:10px;line-height:120%"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774174130/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank">ゲームプログラマのためのコーディング技術</a><div class="azlink-powered-date" style="font-size:7pt;margin-top:5px;font-family:verdana;line-height:120%">posted at 2015.8.17</div></div><div class="azlink-detail">大圖 衛玄<br />技術評論社<br /></div><div class="azlink-link" style="margin-top:5px"><a href="http://www.amazon.co.jp/exec/obidos/ASIN/4774174130/tkoreshiki-22/ref=nosim/" target="_blank">Amazon.co.jp で詳細を見る</a></div></div><div class="azlink-footer" style="clear:left"></div></div>

もうちょっとゲームっぽい具体的なコードを見たいなら、この本の前半を読むといい。
C++ で説明されているので、C++ でゲームを書く人向けではあるが、
良いコードの書き方がステップを踏んで簡潔に説明されている。

（後半のオブジェクト指向設計の部分も非常に真っ当な感じでまとまっているのでおすすめ）

____

以下、本を読む時間のない人のために要点をいくつか挙げよう。

## スコープを小さくする

<div class="key-idea">
<p class="caption">Key Idea:</p>
<p>大きい問題よりも小さい問題の方が扱いやすい。</p>
</div>

スコープというのはざっくり言うと、**「変数や関数の名前が参照可能な範囲」** のことだ。
C 言語ならば波括弧の中身、JavaScript だったら `function() {...}` の中身を
できるだけ小さく保つ、ということを言っている。

なんでこれが嬉しいかというと、登場人物が減って、考えることが少なくて済むようになるからだ。
逆に長い関数の場合、後ろの方に出てきた変数を見て、はて、これはどこから来たのかな、
と読み返すのが大変なことは想像に難くないだろう。

## ネストを小さくする

スコープを小さくするには、ネスト（入れ子構造）も浅く保たなければならない。
次の 2 つの疑似コードは本質的に同じことをやっているが、後者の方が読みやすいはずだ。

```
// ネストが深い状態
if (isA) {
    if (isB) {
        hoge();
        if (isC) {
            if (isD) {
                fuga();
            }
        }
    }
} else {
    piyo();
}
return;
```

```
// ネストが浅い状態
if (!isA) {
    piyo();
    return;
}
if (!isB) { return; }
hoge();

if (!isC) { return; }
if (!isD) { return; }

fuga();
return;
```

ネストが深いと、読んでいた途中のコードを一度頭の中において、その中身を読まなければいけなくなる。
これは疲れる。（「リーダブルコード」では、これを **メンタルスタック** と表現している。）

ネストが深い場合は（設計を見直した方がよい場合もあるが、）
まずは入れ子の中身を他の関数に追い出すことを考えたらよいだろう。
後者のコードで示したような、まず事前条件で弾いてしまう **早期リターン** もよく使われる。
（**「ガード節」** で検索してみよう）

## グローバル変数を避ける

スコープが小さいことは良いことだが、その逆の「スコープが大きい」とはどういうことだろう。
最もスコープが大きいのが、いわゆる **グローバル変数** というやつだ。
グローバル変数は悪しき存在として有名だから、使うべきでないことくらい君はわかっていると思う。
でも世の中には意外と **グローバル変数みたいなもの** が転がっているので、
うっかりこれを使ってしまわないように注意したい。

### 安易なシングルトン

デザインパターンの 1 つとして有名な
[シングルトン](https://ja.wikipedia.org/wiki/Singleton_%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3)
は、初心者がグローバル変数の免罪符として使ってしまいがちなことでも有名だ。
シングルトンは本来「全体で 1 つであることを保証したい」場合に使うものだ。
そして、**そもそも 1 つでなければならないケースはそんなに無い** ということを覚えておいてほしい。

### クラスのメンバ変数はミニグローバル

コードをクラスに分けると何となく安心してしまいがちだが、一般的な言語において
クラスのメンバ変数は **「クラスの中だけで言えばグローバル」** なスコープを持っていることに注意しよう。
クラスベースの言語を使っていたところで、クラスが肥大化して、
その中でメンバ変数が色々なところから代入されていたとすれば、
それはグローバル変数を使っているのと本質的に同じような問題を起こすのだ。

この問題を軽減するには、クラスのメソッドでも引数をとるようにしてメンバ変数にアクセスするといい。

```
// メンバ変数に縦横無尽にアクセスしちゃってる例
class SomeClass {
    int _someValue;

    void method_1() {
        this._someValue = ...;
        method_2();
    }

    void method_2() {
        // this._someValue を使う
    }
    ...
}
```

```
// メンバ変数への直接のアクセスを減らした例
class SomeClass {
    void method_1() {
        // 実はメンバ変数として持たなくてもよいかもしれない
        var someValue = ...;
        method_2(someValue);
    }

    void method_2(someValue) {
        // 引数で渡された someValue を使う
    }
    ...
}
```

### Unity のアレ

これは Unity が用意している API だし、入門書とか Unity のサンプルとかに普通に出てくるので
初心者は普通に使ってしまうと思うけど、

```
var hoge = GameObject.Find("Hoge");
```

どこからでもアクセスできちゃうし、型のあるシステムなのに文字列で指定しちゃってるし、
というか「検索」しちゃってるので負荷も高くてグローバル変数よりもコストが大きい。
小規模なプロトタイプを作る時には使ってもよいと思うが、
中規模以上の開発では使うべきではないものだということを覚えておこう。



