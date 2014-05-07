---
title: 'ソフトウェアのドキュメンテーション'
date: '2013-12-21'
description:
categories: []
tags: [anything, English]
position: 2
---

# ソフトウェアのドキュメンテーションに使われる系英語

- できるだけ直訳っぽくメモ

## 思想・哲学を述べる系

<div class="english">
Ash is <b>prescriptive of the architecture</b> for your code, <i>but of nothing else.</i>
</div>

> **prescriptive**: 規範的な, 慣習 [慣例] で認められた

- Ash は君のコードの構造の規範ではあるが、それ以上の何者でもない


<div class="english">
Ash is written in Actionscript 3 but the <b>principles behind its architecture</b>
may be applied in many other programming languages.
</div>

- Ash は AS3 で書かれているが、そのアーキテクチャの背景にある考え方は他の言語にも適合するだろう



## 書き出し・概要を述べる系

<div class="english">
The IAnimatable interface <b>describes</b> objects that ...
</div>

- IAnimatable インタフェースは 〜 なオブジェクトを表現する


<div class="english">
The "Tween" class <b>is an example of</b> a class that dispatches such an event; ...
</div>

- Tween クラスはそのようなイベントを送出するクラスの一例だ


<div class="english">
A DelayedCall <b>allows you to</b> execute a method after a <i>certain time</i> has passed.
</div>

- DelayedCall は一定時間後にメソッドを実行させられる
    - （直訳：DelayedCall は君に一定時間経過後にメソッドを実行することを許す）


<div class="english">
A class <b>that contains</b> helper methods <i>simplifying</i> Stage3D rendering.
</div>

- Stage3D のレンダリングを簡単にするヘルパーメソッドを含むクラス。


<div class="english">
The Juggler <b>takes</b> <i>objects that implement IAnimatable</i> (like Tweens) <b>and executes</b> them.
</div>

- Juggler は IAnimatable を実装するオブジェクト（Tween とか）を取り、それらを実行する


<div class="english">
A juggler is a simple object.
It <b>does no more than saving</b> a list of objects implementing "IAnimatable"
and advancing their time <b>if it is told to do so</b> (by calling its own "advanceTime"-method).
</div>

- juggler はシンプルなオブジェクトだ。
  IAnimatable を実装したオブジェクトのリストを保持し、
  advanceTime メソッドが呼ばれたオブジェクトの時を進める以上のことをしない。
      - （それらの時間を進める / もしそうしろと命じられたら / それらの advanceTime メソッドを呼ぶことによって）



## これができるよ系

<div class="english">
Any object that implements this interface <b>can be added to</b> a juggler.
</div>

- オブジェクトがこのインタフェースを実装していれば、juggler に add できる
    - （このインタフェースを実装したどのオブジェクトも juggler に add できる）


<div class="english">
Since it implements the IAnimatable interface, it <b>can be added to</b> a juggler.
</div>

- IAnimatble インタフェース実装してるから juggler に add できるよ


<div class="english">
There is a default juggler <b>available at the</b> Starling class: 【コード例】
</div>

- Starling クラスにはデフォルトで使える juggler がある


<div class="english">
It allows manipulation of the <i>current transformation matrix</i> and other helper methods.
</div>

- それによって現在の変換行列（CTM）や他のヘルパーメソッドの操作ができるようになる


## こういうこともできるよ系

<div class="english">
<b>To do this,</b> you can manually remove it <b>via</b> the method juggler.remove(object),
</div>

- これをやるのに、自分で juggler.remove メソッドを呼んで remove することもできる


<div class="english">
... or the object can <b>request to be removed by</b> dispatching a Starling event
with the type Event.REMOVE_FROM_JUGGLER.
</div>

- もしくはオブジェクトが Event.REMOVE_FROM_JUGGLER タイプの event を送出して
  remove されるように要求することもできる


## しなくていいよ系

<div class="english">
<b>In most cases,</b> you do not have to use this class directly;
the juggler class contains <i>a method to</i> delay calls directly.
</div>

- ほとんどの場合はこのクラスを直接使う必要はない。
  juggler クラスは呼び出しを遅らせるメソッドを直接的に含んでいる


<div class="english">
No libraries are required for using Ash.
</div>

- Ash 使うのに（他の）ライブラリは必要ないよ



## 〜のときこうなるよ系

<div class="english">
When an object <b>should no longer be animated,</b> <i>it has to be removed</i> from the juggler.
</div>

- オブジェクトがもうアニメーションするべきでなくなったら、そいつは juggler から remove される


<div class="english">
DelayedCall dispatches an Event of type 'Event.REMOVE_FROM_JUGGLER' when it is finished,
<b>so that</b> the juggler <i>automatically</i> removes it <b>when its no longer needed.</b>
</div>

- DelayedCall はそれが終わったときに 〜 タイプの Event を送出するよ、
  juggler がもう必要なくなったやつを自動で remove できるようにね。


## バージョンにからむ系

<div class="english">
Since Version x.x.x, this API is intentionally deprecated. New code should instead use ...
</div>

- バージョン x.x.x からこの API は意図的に廃止される予定だから、新しいコードでは代わりに ... を使ってね


## 名詞格バリエーション

<div class="english">
objects <b>that are animated depending on</b> <i>the passed time.</i>
</div>

- 経過時間に応じてアニメーションするオブジェクト


<div class="english">
Starling event with the type Event.REMOVE_FROM_JUGGLER.
</div>

- Event.REMOVE_FROM_JUGGLER タイプの Starling イベント



## ありがちフレーズ

<div class="english">
when its no longer needed
</div>

- それがもう必要なくなったときに




<br/><br/><br/>

