---
title: '処理の流れとゲームループ'
date: '2014-08-06'
description:
categories: []
tags: [anything, krewFramework, Manual]
position: 2003
---

# 処理の流れとゲームループ

## フレームワークの設定と起動

Starling の初期化など意外とやることが多いので、
以下で紹介しているスケルトン生成スクリプトでひな形を作ることをおすすめします。

> - [ゲーム開発を始めよう](/krew-framework/krew-skeleton)

スクリプトは、以下のような Main.as を生成します。

> - [Main.as](https://github.com/tatsuya-koyama/krew-skeleton/blob/master/TEMPLATES/core-src/Main.as)

実際には、以下の行で Starling Framework が GameDirector を初期化することで
krewFramework の処理が始まります。

    _starling = new Starling(GameDirector, _rootSprite.stage, viewPort);

なお、KrewConfig の値を変更すると、ログの出力レベルなどを変更できます。


## 全体の処理の流れ

krewFramework は、以下の流れで動き続けます。

  - 0. startGame
  - 1. Scene の初期化
  - 2. Scene が終わるまで、ゲームループを実行
  - 3. Scene が終わったら次の Scene に切り替えて 1 に戻る

### 0. startGame

初めに、GameDirector のコンストラクタで `startGame()` を呼ぶようにします。
これによって初めの Scene が動き出します。

    public class YourGameDirector extends KrewGameDirector {

        // constructor
        public function YourGameDirector() {
            var firstScene:KrewScene = new TitleScene();
            startGame(firstScene);
        }

    }

Global に存在するリソースやレイヤーが GameDirector で定義されていた場合、
このタイミングでリソースの読み込みやレイヤーの作成が行われます。


### 1. Scene の初期化

#### レイヤーをつくる

- Scene で定義されたレイヤーを作ります
- 指定があれば、衝突判定を行うための collision のグループも作られます

#### リソースの読み込み

- Scene で定義されたアセット群をメモリ上に読み込み、リソースとして保持します
- ここで、ロード前やロード後に処理を差し込むこともできます


#### Actor の初期化

- `initAfterLoad()` が呼ばれます
- ここで `setUpActor()` を呼ぶことで、「Scene 開始時にいる Actor 達」を設定します


### 2. Scene が終わるまで、ゲームループを実行

AS3 の ENTER_FRAME イベントにより、毎フレーム `KrewScene.mainLoop()` が 1 回呼ばれます。
1 フレームで行われることは以下の通りですが、
要は **「場にいる全ての Actor の onUpdate が呼ばれる」** と思ってもらえればよいです。

> - Scene の `onUpdate()` が呼ばれる
> - Scene の全レイヤーの `onUpdate()` が呼ばれる
>     - （画面奥のレイヤーから手前のレイヤーの順）
>     - StageLayer はレイヤー上の全 Actor の `update()` を呼ぶ
>         - （ただし Actor が死んでいた場合は、update の代わりに `dispose()` を呼んで破棄）
>         - KrewActor は自分の 子 Actor 達の `update()` を呼ぶ
>             - （ただし子 Actor が死んでいた場合は、update の代わりに `dispose()` を呼んで破棄）
>             - Actor の `onUpdate()` を呼ぶ
>             - スケジューリングされたタスクや tween などの処理のための update を呼ぶ

Scene の update では、**Actor 達の update の後に** 以下のようなことも行われます。

> - Actor が新しい Actor を生み出していたら、それをレイヤーにセットする
> - 衝突判定のヒットテストを行い、衝突があればコールバックを呼ぶ
> - Actor 達によって送られたメッセージをリスナー達に配信する
> - Scene の `exit()` が呼ばれていたらフレームワークに Scene の切り替えを要請

#### メッセージングの仕様

上述の通り、メッセージの送信は Actor 達の update が全て終わったあとに、まとめて行われます。
リスナーのコールバック内でさらにメッセージが投げられた場合は、再び送信を行い、
これをメッセージが発生しなくなるまで続けます。

ここで 2 者がメッセージを投げ合うようなループ構造になってしまった場合、無限ループが発生してしまいます。
規定回数メッセージングがループした場合は、krewFramework はメッセージングの処理を中断し、
エラーログを出力します。この場合はゲームの設計を見直してください。


### 3. Scene が終わったら次の Scene に切り替えて 1 に戻る

Scene 内で `exit()` を呼ぶと、krewFramework はループ終了後に次の Scene への切り替えを行います。
次の Scene は Scene の `getDefaultNextScene()` を実装することで指定します。

なお、`exit(new NextScene());` のように exit の引数で遷移先を指定することもできます。


<br/>

