---
title: 'Markdown の遊び場'
date: '2013-12-02'
description:
categories: []
tags: [anything, Markdown]
position: 3
---

# Markdown の遊び場

## Markdown でメモとドキュメンテーションを

このサイトのコンテンツは Markdown で記述して、
[ruhoh](http://ruhoh.com/) で静的ページに変換している。
ここは html に変換された Markdown が、このサイトのテンプレートでどう見えるかを試すためのページ。

## 見出しレベル２

こんな感じになる。アウトラインは自動で H2 レベルと H3 レベルが左のカラムに表示されるようにしてある。
（これは ruhoh の機能にはなかったので、単に JavaScript でがんばっているだけ。
  拡張 Markdown なら Table of Contents を生成できるものもあるようだが）

### 見出しレベル３

引用した時の見た目はこんな感じ。
> 【引用】[参考リンク](#) とかよくやる

２行以上の引用
> 毎回先頭に > を書かなくても  
> いいみたいだけど書いてもいい

引用のネストもできる。まあ使わないので見た目の調整は今はしない

> 引用レベル１

>> 引用レベル２

> - リストを引用
> - リストを引用

#### 見出しレベル４

途中で改行したい場合は  
Markdown では末尾にスペース２つを入れるらしい。

_これ_ とか *これ* が斜体で、  
__これ__ とか **これ** が強調。

---
_____
***
- - - - -

こうやると水平線が引ける。（書き方は亜種がいっぱいある）

## リスト

よく使うよね

- Item 1
- Item 2
    - Item 2-1
        - Item 2-1-1
    - Item 2-2
- Item 3

リストを始めるときには空行を挟まないといけないので注意。

* これでもリストになる

+ これでもリストになる

1. 順序リストは
1. このように
1. やる

## コード

Google Prettify の力で整形する。
こいつは Syntax Highlighter などと違ってコードの種類を自動判別してくれるから
Markdown との相性がいい。例えば ActionScript3.0 のコード：

    package tatsuyakoyama.tkutility {

        import flash.utils.getQualifiedClassName;
        import mx.utils.StringUtil;
    
        //------------------------------------------------------------
        public class TkUtil {

            public static var debugMode:Boolean = false;
    
            /**
             * Select function randomly from weighted function list,
             * using Roulette Wheel Selection algorithm.
             *
             * @param candidates Array such as:
             *     [
             *         {func: Function1, weight: 30},
             *         {func: Function2, weight: 70}
             *     ]
             */
            public static function selectFunc(candidates:Array):void {
                var totalWeight:Number = 0;
                for each (var data:Object in candidates) {
                    totalWeight += data.weight;
                }

                var selectArea:Number = rand(totalWeight);
                var weightCountUp:Number = 0;
                for each (var data:Object in candidates) {
                    weightCountUp += data.weight;
                    if (weightCountUp >= selectArea) {
                        data.func();
                        return;
                    }
                }
            }

## 画像埋め込み

URL 指定。ruhoh では { { urls.media } } で media ディレクトリ以下に置いたファイルを引ける。

Markdown で画像を入れるならこうだ：

    ![alt_text]({{urls.media}}/img.jpg)

画像にリンクを貼りたい場合は、これ自体をリンクの構文で囲んでやればできる：

    [ ![alt_text](画像パス) ](飛び先 URL)

だがこの辺は見た目を整えるために css を指定したくなる。
かと言ってデフォルトの img にスタイルを適用させると他の場所にも影響が出て厄介だ。
結局画像に関しては直接タグを書く方が無難だろう。

    <img class="photo" src="{{urls.media}}/mew.jpg" />

<img class="photo" src="{{urls.media}}/mew.jpg" />

> 【注】画像は実家の猫。マジかわいい


## テーブル

GitHub だと拡張構文でこんな書き方すればテーブルになってくれるけど、
純粋な Markdown だと表組みはサポートされてない。

    item1|item2|item3
    ---|---|---


    | item1 | item2 | item3 |
    |:---:|-----|----:|
    | item4 (centering) | item5 long text | item6 (right align) |
    | アイテム7 | アイテム8 | **強調** も可能 |
    | hoge | fuga | piyo |
    | hoge | fuga | piyo |
    | hoge | fuga | piyo |

### 実際にやるとこう

item1|item2|item3
---|---|---


| item1 | item2 | item3 |
|:---:|-----|----:|
| item4 (centering) | item5 long text | item6 (right align) |
| アイテム7 | アイテム8 | **強調** も可能 |
| hoge | fuga | piyo |
| hoge | fuga | piyo |
| hoge | fuga | piyo |

- ruhoh の Markdown のパーサを入れ替えるという解決策もありそうだが
  セットアップ手順増えるしめんどい。
- 諦めてテーブルタグ書くのがいいかな


<table class="mystyle">
    <tr class="head">
        <td>item1</td>
        <td>item2</td>
        <td>item3</td>
    </tr>
    <tr class="color1">
        <td class="left">item4</td>
        <td>item5</td>
        <td>item6 is semi-long text</td>
    </tr>
    <tr class="color2">
        <td class="left">item7</td>
        <td>**強調とか使えない**</td>
        <td>item9</td>
    </tr>
    <tr class="color1">
        <td class="left">item10 hoge</td>
        <td>item11</td>
        <td>item12</td>
    </tr>
</table>


## いざとなったら

まあ html が普通に書けるのでどうしようもなく困ったらタグを書こう。

<br/><br/><br/><br/>

