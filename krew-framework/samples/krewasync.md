---
title: 'KrewAsync'
date: '2014-03-04'
description:
categories: []
tags: [anything, krewFramework, SampleCode]
position: 3003
---

# Sample Code | KrewAsync

## KrewAsync

{{# flashModal }}
  id   : flashMordal_krewasync
  title: KrewAsync
  swf  : "{{ urls.media }}/swf/krewsample/krew-sample-krewasync.swf"
{{/ flashModal }}

<a href="https://github.com/tatsuya-koyama/krewFramework/tree/master/samples/projects/krew_async/core-src"
   class="btn large-btn clearfix">
  <img class="btn-icon" src="{{urls.media}}/krewfw/GitHub-Mark-64px.png" width="28" height="28" />
  View Full Source Code
</a>

- 非同期処理を含むシーケンスを Deferred パターンのように記述できるライブラリとして、
  KrewAsync というクラスを用意しています。

### KrewAsync.as

<div style="float: left;  margin-right: 3.0em;">

  <a href="https://github.com/tatsuya-koyama/krewFramework/blob/master/krew-framework/krewfw/utils/as3/KrewAsync.as"
     class="btn large-btn clearfix"
     style="margin-left: 1.0em;">
    <img class="btn-icon" src="{{urls.media}}/krewfw/GitHub-Mark-64px.png" width="28" height="28" />
    Source Code
  </a>

  <ul>
    <li>
      <a href="https://github.com/tatsuya-koyama/krewFramework/blob/master/test/src/krewfw_utils/tests/KrewAsyncTestCase.as">
        Test Cases
      </a>
    </li>
  </ul>

</div>

<ul>
  <li>KrewAsync は ActionScript3.0 にのみ依存するクラスなので、krewFramework の外でも利用可能です。</li>
</ul>
<div class="clearfix"></div>


#### Usage

        /**
         * Sequence:
         *                |4 ->..|
         *           |3 > |      |...|
         *           |    |5 --->|   |
         *   1 > 2 > |               | > 8
         *           |               |
         *           |6 ----- 7 ---->|
         */
        import krewfw.utils.as3.KrewAsync;

        private function _goAsyncSequence():void {
            krew.async({
                serial: [
                    _yourFunction_1,
                    _yourFunction_2,

                    {parallel: [
                        {serial: [
                            _yourFunction_3,
                            {parallel: [
                                _yourFunction_4,
                                _yourFunction_5
                            ]}
                        ]},
                        {serial: [
                            _yourFunction_6,
                            _yourFunction_7
                        ]}
                    ]},

                    _yourFunction_8
                ],
                error : _onCatchError,
                anyway: _finallyHandler
            });
        }

        private function _yourFunction_1(async:KrewAsync):void {
            someAsynchronousTask(function():void {
                // callback
                if (CONDITION_IS_OK) {
                    async.done();
                } else {
                    async.fail();
                }
            });
        }

___

## 概要

### 何が嬉しい

- 普通に書くと煩雑になる非同期処理のシーケンスを、上から下にすっきり書けます
- シーケンスの一部をクラスオブジェクトにまとめて使い回すこともできます
- catch 節に当たるエラーハンドリングと、finally 節にあたる終了処理が指定できます
- クラス 1 個のピュア AS3 で軽やか

### 特徴

- よくある Deferred パターンのように、メソッドチェーンではありません
    - シーケンスを記述した Object (JSON) を渡して実行させます
- インスタントに Object を記述してもよく、KrewAsync のサブクラスを作ってそれを渡してもよいです
    - JS の JSDeferred よりも AS3 らしく、クラスに実装をまとめて使い回せるのがメリットです
- 途中で動的に処理を追加したりとか、分岐したり、指定回数ループさせたりとかは考えていません
    - 分岐とかをやりたくなったときは krewFramework の KrewStateMachine と組み合わせるのがおすすめです

## 書き方

### 基本

例えば `function_1`, `function_2`, `function_3` をシーケンシャルに実行したい場合は、以下のように書きます。

    import krewfw.utils.as3.KrewAsync;

    var async:KrewAsync = new KrewAsync({
        serial: [function_1, function_2, function_3]
    });
    async.go();

### ショートカット

`krewfw.utils.krew` を import すれば、以下のように書くだけで実行されますので、こちらがおすすめです。

    import krewfw.utils.krew;

    krew.async({
        serial: [function_1, function_2, function_3]
    });


## 仕様

### 直列実行と並列実行

シーケンシャルに実行したい場合は Object のキーに `serial` を、
パラレルに実行したい場合は `parallel` を指定し、Function の配列を渡します。
全ての処理が終わった時、`anyway` に指定した関数が実行されます。
（`anyway` は指定しなくても構いません。）

    // function_1, 2, 3 を順次実行、最後に 4 を実行
    krew.async({
        serial: [function_1, function_2, function_3],
        anyway: function_4
    });

    // function_1, 2, 3 を同時に処理開始、全部終わったタイミングで 4 を実行
    krew.async({
        parallel: [function_1, function_2, function_3],
        anyway  : function_4
    });

> serial と parallel はどちらか片方しか指定できません。両方指定した場合は Error を投げます。

### 実行する関数の書き方

渡す関数は引数に KrewAsync のインスタンスを受け取ります。
処理が正常に完了した場合にそのインスタンスの `done()` を、
エラー時に `fail()` を呼ぶようにしてください。

    private function function_1(async:KrewAsync):void {  // Receives KrewAsync

        someAsynchronousTask(function():void {  // callback
            if (CONDITION_IS_OK) {
                async.done();  // Success !
            } else {
                async.fail();  // Error...
            }
        });
    }

### 直列と並列の組み合わせ

`krew.async` に渡す引数の Object を `<asyncDef>` としたとき、
`serial` と `parallel` の Function を指定する部分には、
**Function の代わりに `<asyncDef>` を指定することもできます。**
これにより、直列と並列のタスクを組み合わせて連鎖させることができます。

    /**
     *           3 -> |
     * 1 -> 2 -> |    | -> 5 -> 6  という順で処理したい場合
     *           4 -> |
     */
    krew.async({
        serial: [
            function_1,
            function_2,

            //----- nested Object -----
            {
                parallel: [
                    function_3,
                    function_4
                ],
                anyway: finally_func_1
            },
            //-------------------------

            function_5,
            function_6
        ],
        anyway: finally_func_2
    });

上記の例では、以下のような実行順になります。

- `function_1` を実行
- 完了後、`function_2` を実行
- 完了後、`function_3`, `function_4` を同時に実行開始
    - 2 つとも完了したタイミングで、`finally_func_1` を実行（これは終了を待たない）
- 3 と 4 が完了後に、 `function_5` を実行
- 完了後、 `function_6` を実行
- 完了後、 `finally_func_2` を実行（これは終了を待たない）

___

少し記述が複雑になりますが、並列タスクの中に並列タスクを入れ子にすることも可能です。

    /**
     *           3 ------> |
     * 1 -> 2 -> |         | -> 7
     *           |    5 -> |
     *           4 -> |    |
     *                6 -> |
     */
    krew.async({
        serial: [
            function_1,
            function_2,
            {parallel: [
                function_3,

                {serial: [
                    function_4,
                    {parallel: [
                        function_5,
                        function_6
                    ]}
                ]}
            ]},
            function_7
        ]
    });


## エラー処理

`error` に Function を指定することで、途中で `async.fail()` が呼ばれた場合のエラーハンドリングができます。
`error` を try-catch-finally 構文の catch 節、
`anyway` を finally 節だと思えば分かりやすいでしょう。

    // function_1, 2, 3 を順次実行、
    // 途中で fail() が呼ばれたら次の処理に進まず _onErrorHandler を呼ぶ。
    // エラーが発生したかどうかに関わらず、最後には _finallyHandler が呼ばれる
    krew.async({
        serial: [function_1, function_2, function_3],
        error : _onErrorHandler,
        anyway: _finallyHandler
    });

    // function_1, 2, 3 を同時に処理開始、
    // いずれかで fail() が呼ばれたら _onErrorHandler を呼ぶ。
    // エラーが発生したかどうかに関わらず、最後には _finallyHandler が呼ばれる
    krew.async({
        parallel: [function_1, function_2, function_3],
        error   : _onErrorHandler,
        anyway  : _finallyHandler
    });

- `error`, `anyway` には引数をとらない `function():void {...}` を指定します。


### 入れ子の場合のエラー処理

タスクが入れ子になっている場合は、`error` と `anyway` は内側から順に呼ばれます。

    /**
     *           3 -> |
     * 1 -> 2 -> |    | -> 5 -> 6
     *           4 -> |
     */
    krew.async({
        serial: [
            function_1,
            function_2,
            {
                parallel: [
                    function_3,
                    function_4
                ],
                error : onError_1
                anyway: finally_1
            },
            function_5,
            function_6
        ],
        error : onError_2
        anyway: finally_2
    });

上記の場合、

- 例えば `function_3`, `function_4` のどちらかで `fail()` が呼ばれた場合は、
    - まず `onError_1` が呼ばれ、次に `finally_1` が呼ばれます
    - `function_5` 以降は実行されず、
    - `onError_2` が呼ばれ、次に `finally_2` が呼ばれます

___

- 外側の `function_2` で `fail()` が呼ばれた場合は、
    - （`function_3` 以降は実行されず、`onError_1`, `finally_1` も呼ばれません）
    - `onError_2` が呼ばれ、次に `finally_2` が呼ばれます


## クラスを使った記述

処理の一部分を複数箇所で使い回したり、パラメータを与えて処理を動的に組み立てたくなることもあります。
その場合は、処理を KrewAsync サブクラスに記述する方法が有効です。

例として以下のコードで、**「3 と 4 の並列実行とエラー処理の部分」をクラス化する** ことを考えます。

    /**
     *           3 -> |
     * 1 -> 2 -> |    | -> 5 -> 6
     *           4 -> |
     */
    krew.async({
        serial: [
            function_1,
            function_2,
            //----- ここを切り出してまとめたい -----
            {
                parallel: [
                    function_3,
                    function_4
                ],
                error : onError_1
                anyway: finally_1
            },
            //------------------------------------
            function_5,
            function_6
        ],
        error : onError_2
        anyway: finally_2
    });

KrewAsync クラスを継承したクラスを作り、自身を Object で初期化するようにします。

    import krewfw.utils.as3.KrewAsync;

    public class MyKrewAsyncSubTask extends KrewAsync {
        public function MyKrewAsyncSubTask() {
            super({
                parallel: [
                    function_3,
                    function_4
                ],
                error : onError_1
                anyway: finally_1
            });
        }

        private function function_3(async:KrewAsync):void { ... }
        private function function_4(async:KrewAsync):void { ... }

        private function onError_1():void { ... }
        private function finally_1():void { ... }
    }

先ほどの例はこのクラスのインスタンスを使って次のように書けます。

    krew.async({
        serial: [
            function_1,
            function_2,
            new MyKrewAsyncSubTask(),
            function_5,
            function_6
        ],
        error : onError_2
        anyway: finally_2
    });



<br/><br/><br/><br/>
それでは、よい非同期処理ライフを。

