---
title: '（まとめる前のドラフト）'
date: '2013-12-10'
description:
categories: []
tags: [anything, krewFramework]
position: 9901
---

# まとめる前のドラフト

## Demo Flash のモーダル表示テスト

{{# flashModal }}
  id   : flashMordal_globalLayer
  title: Global Layer
  swf  : "{{ urls.media }}/swf/krewsample/krew-sample-global-layer.swf"
{{/ flashModal }}

<div class="clearfix"></div>

## ウリ

### Actor の書き心地

- 基本的に Actor を作っていくフレームワークなので、Actor の書きやすさを手厚く
    - よく使うゲーム向けユーティリティには、Actor からは krew.rand(); のようにアクセスできる

### krew.as

- krewFramework 同梱の、ゲームコーディング向けユーティリティ
- AS3 でゲーム書くときの underscore.js 的な存在にしたい
- 以下のようにインポートしておけば krew.rand(); みたいに利用できる
  （KrewActor はメソッドを持っているのでインポートの必要すらない）

        import krewfw.utility.krew;

___

- 実態は krewfw.utils.KrewTopUtil で、シングルトン
    - static でなくシングルトンにしたのは、継承やすげ替えを可能にするため


## ポリシーとかスタンス

- **重複の排除と、よくタイプするものの効率化**
    - どうせやるようなことは書かせない
    - よく書きたくなるものはタイプ数が少なくてすむように

___

- **いざとなったら Starling**
    - 基本よくやるゲームの制御は Starling 意識しないで使えるインタフェースにはしておく
    - とはいえ Starling まわりのソフトウェア資産は充実してるので使わない手はない
        - Starling の Extension とか、UI 作るときの Feathers とか
        - ってか Starling ならまあ Feathers 使いたいよね
    - KrewActor は starling.display.Sprite のサブクラスなので Starling の DisplayObject なら
      普通に addChild できる

> 【大きめToDo】 Starling の部分をコンポジションにして別の View にも差し替え可能にする

___

- **できるだけ Actor 指向**
    - Actor でできる範囲のことは、できるだけ Actor でやる
        - (1) 毎フレーム場にいる Actor 達の update が呼ばれる
        - (2) Actor はメッセージを投げられる
        - (3) Actor はメッセージを listen できる
        - (4) Actor は別の Actor を場に生み出せる
        - (5) Actor は自滅できる
    <br/><br/>
    - 汎用的に使える機能を作っていくと、ビルトインの Actor 達が増えていくイメージ
        - 使いたい人はシーンにその Actor を投げ込めばいい
        - 使いたくなくなったらその Actor をシーンから外せばいいだけ
        - プラガブルで依存性が低い構成にできる

___

- **ちょっとした tween とかレイアウトはコードで書けちゃうように**
    - アーティスト領域っぽいちょっとした動きのディティールとか、コードで書けるようにしても罪じゃないと思う
    - イージングとかも 1 行で書けるように
    - コーディングとアニメーションができる Flasher 指向
        - 大規模開発ならともかく、この辺完璧にデータ駆動にするのは手間
        - コードで書けると、ちょっとしたプロトタイプ作るときにも重宝する

___

- **Actor はある程度ゲームスクリプトみたいなものと見なす**
    - テクスチャ名とか座標とかちょっとした動きの制御とか中にコードで書いちゃっていいと思う
    - ビルド重い言語だったらこの辺をスクリプトにするけど、AS3 のコンパイルから起動までは数秒で終わるし
    - 大掛かりだったり量産したいデザインは仕組みつくってデータ駆動にしてよいし、
      汎用的に使いたい UI みたいな Actor だったらパラメータ外出ししてよいけど
    - ゲーム specific なコードのパラメータを外に出すのもやりすぎると手間が増えるだけ
        - 程度と粒度をどれくらいにするか、という決めの問題


## 決まり事

- KrewActor は starling.display.Sprite なので Starling の DisplayObject 系統を addChild できる
- ただし Image は addImage, TextField は addText を推奨
    - krewFramework は Actor の破棄時に自動的にその Actor が持つ DisplayObject の dispose を呼ぶ
    - addImage, addText で足すと KrewActor.color を指定したときに全てがその影響を受ける
    - addImage ではついでに位置やアンカーも指定できる
        - AS3 はオーバーロードが無いから引数増えると override できないんだよねー
        - あとなんか Image のアンカーの指定にクセがあったのでここで吸収した
    - あと Image の破棄時に image.texture.dispose 呼んでやらないとメモリがアレだと思った記憶があるんだけど、
      Starling のソース見た感じ別に必要ない？


## Tips

- Draw Call を減らすには
    - 1 レイヤーに表示させるものを 1 アトラスにまとめるとよい
    - 単純な Painting Algorithm だからね


## コーディングガイドライン

- Scene は基本的にアセット一覧や setUpActor を並べるだけのイメージ
    - Actor の初期化のための private メソッドとかでもあんまり足さない方がいい
    - Scene は「これとこれとこれを使う」と指定するだけの場所。Actor 固有の処理はできるだけ Actor にまとめる
        - 初期化のためのカスタマイズが複雑になるなら Factory 的な Actor を一枚かましてそいつを setUpActor するとか
    - つけ外しの「外し」が容易かどうか、ということを気にする


## コーディングスタイル

- 思想は書籍「リーダブルコード」に概ね賛成
- ちょっとした作業変数だったとしても、変数名はできるだけ省略しない
    - 書く労力は一度だけ、読む方を楽にする精神
- スペースによる整形は積極的に行う
    - 同じようなことを並べている場合は、同じようなことをやっているように見せるポリシー

___

- 参考
    - [Google Java Style](http://google-styleguide.googlecode.com/svn/trunk/javaguide.html#s5.2.2-class-names)
    - [Python - PEP8](http://www.python.org/dev/peps/pep-0008/)

___

- 世の多数派に合わせ、インデントはスペース（僕ももともとはタブ派だったが）
- 4 スペースを使う
- 行末のスペースは許さない。これに従い、改行目的でもスペースだけの行は作らない
    - （Emacs で delete-trailing-whitespace した状態）

___

- 括弧や演算子のスペースの入れ方なども多数派（と思われるもの）に合わせる
- インクリメントは基本的に無難な前置
- これは完全に僕個人のクセであることを認めるが、if の && 前後や for のセミコロンの後ろには
  スペースを 2 つ入れてしまう。区切りが見やすいから…

        if (condition == true  &&  anotherCondition == false) {
            aInstance.doSomething(arg1, arg2);
            someVar = someVar + 3;
            ++someVar;
        }

        for (var i:int = 0;  i < numList.length;  ++i) {
            var elem:Number = numList[i];
            // do something
        }

___

- 関数名の後の波括弧は同じ行に置く（FlashBuilder のデフォルトとは異なるが、if などと合わせたい）
- 初期値の = などは個人的にはスペース入れたいが、多数派に合わせてスペース入れない

        publich function hoge(fuga:Number, piyo:Number=0):void {
            // do something
        }

___

- これも個人的なスタイルだが、大きい配列・オブジェクトで要素を並べるときに、
  追加と削除がしやすいように先頭にカンマを持ってくることがある
      - Perl などのように末尾のカンマが許されているなら、全部行末につけるけどね

            var someObj:Object = {hoge: 1, fuga: 2};
            var someList:Array = [1, 2, 3];
    
            var actors:Array = [
                 new HogeActor(args1, args2)
                ,new FugaActor(args1, args2, args3)
                ,new PiyoPiyoActor(args1)
            ];


___

- 命名はキャメルケース
- クラス名は大文字から、それ以外は小文字から
- 定数名は大文字でアンダーバー区切り
- package 内はインデント
- private, protected な変数名、関数名には先頭に _ をつける（JavaScript でよく見られるスタイル）

        package com.tk.something {

            public class MyClass {

                private const MY_CONST_VALUE:int = 100;

                public var hogeNum:Number;
                private var _fugaNum:Number;
                protected var _piyoNum:Number;

                public function myFunc():void {
                    // ...
                }

                private function _mySecretFunc():void {
                    // ...
                }

            }

        }


## パッケージの分け方

- core_internal にはシステムの基幹だがフレームワークのユーザがインタフェースを知らなくても構わないものを入れる
- utility には ActionScript にしか依存しないユーティリティ（距離の計算とか単位の変換とか）を入れる
    - Starling に依存するユーティリティは starling_utility に入れる
- builtin_actor にはゲームやパフォーマンステスト用のデモを作る過程で生まれた Actor を入れておく
    - ここに入れるものは、特定のリソース名やコンテキストに依存しないようにパラメータを外から指定できるように作る

## 開発の流れ

### あなたがやるべきこと

#### 0. krewFramework の設定

- Main かなんかで、krewfw.KrewConfig の変数の値をカスタマイズ
- NativeStageAccessor.stage に root の stage をセットするのはやらんといけない

#### 1. GameDirector を 1 つ用意

- KrewGameDirector を継承したクラスを 1 つ書く
- こいつを Starling の コンストラクタに渡す
- 【必須】最初の Scene の指定を行う
- 【Optional】ゲーム全体で持ちたいグローバルなリソースの指定を行う

        package {

            import yourgame.scene.BootScene;
            import krewfw.core.KrewGameDirector;
        
            public class YourGameDirector extends KrewGameDirector {

                public function YourGameDirector() {
                    var firstScene:KrewScene = new BootScene();
                    startGame(firstScene);
                }
        
                protected override function getInitialGlobalAssets():Array {
                    return [
                         "image/atlas_first.png"
                        ,"image/atlas_first.xml"
                    ];
                }
            }
        }

___

- 現状 krewFramework は Starling 依存で、Starling 使う前提のフレームワーク
- Main （プログラムのエントリ）で Starling に GameDirector を渡してやろう

        _starling = new Starling(YourGameDirector, stage, viewPort);


#### 2. Scene を画面の数だけ用意

- タイトル画面、ゲーム画面、リザルト画面などがそれぞれ Scene になり得る
- krewFramework のおける Scene とは、「リソースをメモリに読み込むスコープ」だと思ってほしい

___

- Scene がやるのは以下
    - そのシーンに必要なリソースの指定
    - そのシーンのレイヤー定義
    - 【Optional】衝突判定のグループ定義
    - 「シーン開始時に存在しているべき Actor 達」を並べる

#### 3. Scene で使う Actor を適宜実装

- Scene が始まってからの仕事はできるだけ Actor に任せる
- 各 Actor を実装する
- Actor 同士の連携はメッセージングで
    - 各 Actor は「こういうメッセージが来るだろう」想定で書く

___

- Actor は「Scene でこういうものが準備されているだろう」前提で書いてしまってよい
    - 引数で渡してやってもよいが、汎用的な Actor 以外は前提を持ってしまってよいだろう
    - 要は、ある程度「Actor は Scene を構成するための書き捨てスクリプト」のように作ってしまってよいという思想
- Scene で定義・準備されていることを期待しちゃうもの
    - リソース
    - レイヤー名
    - コリジョンのグループ名





## krewFramework がやっている処理の流れ

### GameDirector がゲームの初期化と、初めの Scene を起動

- あなたが継承した GameDirector の中で

        startGame(initialScene);

___

- KrewSharedObjects が new される
    - 以後、これの参照が各 Scene, Actor に引き回される
- `_loadGlobalAssets` で「ゲーム中ずっと持つリソース」がメモリに読み込まれる
- `_startScene`
    - Scene の初期化処理
    - Scene を addChild して表示リストにのせる
        - （GameDirector も Scene も Starling の Sprite）
    - EXIT_SCENE イベントを listen する

### Scene の初期化処理

- `KrewScene.startInitSceneSequence`

#### レイヤーをつくる

- あなたが override した `getLayerList` をもとに、レイヤーを作る
    - （暗黙で `_system_` レイヤーも足す）
    - （`_system_` レイヤーにはフェード用の `krewfw.builtin_actor.display.ScreenFader` が addActor される）
    - レイヤーは、レイヤーごとに starling.animation.Juggler を所持している

#### その他の初期化

- 同様に collision のグループも作る
- （Scene が Actor っぽい仕事をするためのサポート Actor を `_system_` レイヤーに足す）
- `initLoadingView`
    - レイヤーはできている。Loading 表示用の Actor などを setUpActor する
- `getAdditionalGlobalAssets` が定義されていれば、追加グローバルアセットをメモリに足し込む
- `getRequiredAssets` が定義されていれば、シーンアセットをメモリに読み込む

#### 準備完了、初期 Actor のセットアップ

- `initAfterLoad`
    - ここからリソースの準備が整って動き出せる状態
    - `initLoadingView` で出した Actor はここで passAway するなど
    - ここであなたが初期 Actor 達を `setUpActor` する


### Scene のメインループ

- KrewScene はコンストラクタで `starling.display.DisplayObject.addEventListener` を呼んでいる
    - `starling.events.Event.ENTER_FRAME` を登録してる
    - これによりメインループが呼ばれる
    - **だからコンストラクタをサブクラスで書いたら `super` 呼んでおかないとループが回らなくなるので注意**
- ENTER_FRAME のイベントで呼ばれるのは `KrewScene.mainLoop` のみ

#### 1 フレームで行われること

- 以下、1 フレームに行われる処理
    - Scene の `onUpdate` を呼ぶ

##### Actor 達の update
- 全レイヤーの `onUpdate` を呼ぶ
    - 奥のレイヤーから手前のレイヤーの順で、レイヤー単位で update
    - 以下、StageLayer の `onUpdate`
        - Layer 上の全 Actor の `update` を呼ぶ
        - （Actor の `passAway` が呼ばれていた場合は、update を呼ばず `dispose` を呼んで破棄）
        - 以下、KrewActor の update
            - まずは自分の子 Actor 達を update
            - （`passAway` 呼ばれてたら update を呼ばす `dispose` を呼んで破棄）
            - Actor の `onUpdate` を呼ぶ
            - timeKeeper の update （delayed とか cyclic とかの処理）
            - _updateAction で tween 系の update

> ToDo: Layer と Actor で同じようなことやってるの、これひとつにできるんじゃん？

##### Scene の onUpdate つづき

- Actor が `createActor` によって新しい Actor を生んでいたら、Scene がそれらを `setUpActor` する
- collision のヒットテストを行い、衝突があればコールバックを呼ぶ
- Actor 達によって送られていたメッセージを listener に配信
    - listener のコールバックでさらにメッセージが呼ばれた場合、再び配信
    - メッセージが発生しなくなるまで行われる
    - （ただし規定回数ループしてまだある場合はエラーとして中断。デフォルトは 8 回）
    - （メッセージがループになるのは設計が間違っている）
- Scene の `exit` が呼ばれていたならここで `KrewSystemEventType.EXIT_SCENE` を `dispatchEvent`

> ENTER_FRAME と EXIT_SCENE は krewFramework のメッセージングではなく
> Starling のイベントシステムでやっている

## onUpdate に渡される passedTime

- ある程度まで FPS 落ちたら「コマ落ち」じゃなく「処理落ち」になるような時間を渡している
- FPS がどこまで落ちても「コマ落ち」で許すかは、`KrewConfig.ALLOW_DELAY_FPS` で指定





## GameDirector を作る

- ToDo

## Scene を作る

### あなたが override できる KrewScene のハンドラ一覧

{{# table }}
  -
    - 関数名
    - できること
    - 実装すべきこと
  -
    - getRequiredAssets
    - そのシーンに必要なアセットを定義できる。ここで指定するとシーン初期化時に自動で読み込んでくれる
    - アセットのファイル名の配列を返す
  -
    - getLayerList
    - ゲーム画面のレイヤー構造（表示の前後関係や時間軸を適用させるグループ）を定義できる
    - レイヤー名の文字列の配列を返す。先頭の要素が最も奥に表示される
  -
    - getCollisionGroups
    - 衝突判定を行いたい者を放り込むためのグループを定義できる
    - グループ名と衝突判定相手のグループを定義するための、配列の配列を返す
  -
    - initLoadingView
    - ローディング画面を作れる
    - 画面を構成するための Actor をセットする
  -
    - onLoadProgress
    - ローディングの最中の処理を定義できる
    - 引数にロードの進捗率が来るので、それを使って何かやる。
      このハンドリングは Actor がシステムイベントを listen することでも実現できる
  -
    - onLoadCpmlete
    - ロード完了時の処理を定義できる
    - やりたい処理を書く
  -
    - initAfterLoad
    - アセット読み込み完了後の、シーンの本命の初期化処理を定義できる
    - シーンの冒頭で必要な Actor のセットや、イベントの listen を行う
  -
    - getDefaultNextScene
    - 次のシーンの行き先を定義できる
    - 次のシーンのインスタンスを返す。exit() を呼んだ場合、ここで返しているシーンに自動的に遷移する
{{/ table }}



### 基本的なシーンの実装例

    package your.namespace {

        import com.tatsuyakoyama.krewfw.core.KrewScene;
        import your.actors.*;

        // KrewScene を継承する
        public class YourGameScene extends KrewScene {

            // このシーンで必要なアセット群を定義
            // これらはシーンの初期化時に読み込まれ、
            // シーンが終わるときに自動的に破棄される
            public override function getRequiredAssets():Array {
                return [
                     "image/atlas_game.png"
                    ,"image/atlas_game.xml"
                    ,"bgm/nice_music.mp3"
                ];
            }

            // このシーンにおける、ゲーム画面のレイヤー構造を定義
            public override function getLayerList():Array {
                return ['l-back', 'l-front', 'l-ui', 'l-filter'];
            }

            // アセットのロード開始時の画面をつくる
            // ここでセットする Actor はグローバルにロード済みのアセットしか使えない
            public override function initLoadingView():void {
                setUpActor('l-back', new YourLoadingIndicatorActor());
            }

            // アセットのロード中に呼ばれる。loadRatio は 0 から始まって、
            // 読み込み完了時に 1 が渡る    
            public override function onLoadProgress(loadRatio:Number):void {
                ...
            }

            // アセットのロード完了時に呼ばれる。この直後 initAfterLoad が呼ばれる
            public override function onLoadComplete():void {
                ...
            }

            // シーンの本命の初期化処理。ここから上で定義したアセットにアクセスできる
            // このシーンの初期状態に必要な Actor 達をセットすることでゲームを形作る
            public override function initAfterLoad():void {
                playBgm('nice_music');

                setUpActor('l-back',  new YourBackgroundActor());
                setUpActor('l-front', new YourPlayerCharacterActor());
                setUpActor('l-ui',    new YourHeadUpDisplayActor());

                blackIn(0.5);  // 黒からのフェードインを簡単に行うヘルパー

                // イベントを待ち受ける
                listen("Your_Game_End_Event", _onGameEnd);
            }

            // 上で listen したイベントのハンドラ
            private function _onGameEnd(eventArgs:Object):void {
                exit();  // これを呼ぶとシーン終了の合図
            }

            // exit が呼ばれると、次はここで返しているシーンへ遷移する
            // なお exit(specificScene) とすると、引数で渡したシーンに遷移し
            // この関数は無視される
            public override function getDefaultNextScene():KrewScene {
                return new YourResultScene();
            }
        }
    }


## Actor を作る


## Actor のユニットテストを書くには




<br/><br/>

