---
title: 'システムの全体観'
date: '2014-08-06'
description:
categories: []
tags: [anything, krewFramework, Manual]
position: 2003
---

# システムの全体観

## krewFramework の構造

krewFramework が動作しているときの各コンポーネントの関係は、以下のようになっています。

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/krewfw/krew-system-overview.png"
       style="width: 100%; max-width: 847px;" />
</div>

<br/>
最も土台にあるものが **GameDirector** です。
これはゲーム中に 1 つ存在し、常に 1 つの **Scene** を持ちます。
Scene が終了したとき、次の Scene に切り替える役目を担います。

Scene は、多層の **StageLayer** を持ちます。
StageLayer は画面の表示の前後関係や、タッチ可能の有無をレイヤー単位で管理するために使われます。
この StageLayer に **Actor** が乗ります。

### Actor = starling.display.Sprite

Actor は Starling Framework の Sprite クラスを継承しています。
実際のところ、StageLayer に Actor が乗っている状態は、
Starling の Display Tree （シーングラフ）が作られている状態と同等です。

Actor は Sprite ですが、krewFramework のインタフェースを用いている限りは
addChild / removeChild などを自分で書く必要はありません。

> View を別に分ける設計も妥当ですが、今回は割り切ってこのようにしました

### Resource の管理

krewFramework は Scene 単位でリソースを管理します。
Scene に必要なアセットのファイルパスを記述しておくと、
krewFramework は ResourceManager にリソースを保持します。

> Global スコープや複数の Scene をまとめたスコープでもリソースを持つことができますが、
> 最小のスコープは Scene 単位です

Actor は自分に必要なリソースが読み込まれている前提で、
自身のインタフェースを用いてリソースを取得します。

    // Actor 内で
    var image:Image = getImage("resource_name");

Scene が終わって次の Scene に遷移するとき、krewFramework は自動的に Scene のリソースを解放します。

### Actor 同士のメッセージング

Actor は StageLayer に乗っている間、他の Actor にメッセージを送ったり、
逆に特定のメッセージを受け取ったりすることができます。
（いわゆる Publisher / Subscriber 型の通信です。）

krewFramework 上に static に 1 つ存在する NotificationService が、
これを処理しています。Actor は以下のようにメッセージ（= イベント）を待ち構えることができます。

    // メッセージのリスナー登録
    listen("Event_from_others", _myCallbackFunction);

listen を呼ぶと、Actor がこのメッセージの Observer として NotificationService に登録されます。
また、以下のようにメッセージを発信することができます。

    // 他の Actor 達にメッセージを送る
    sendMessage("Event_from_me");

sendMessage を呼ぶと、メッセージは一時的に NotificationService に保持されます。
各ゲームループの最後に、そのメッセージを listen している Actor 達に向けてメッセージが送られます。

Actor が破棄されるとき、krewFramework はリスナーの登録解除などを自動で行います。


<br/>

