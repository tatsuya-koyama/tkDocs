---
title: 'まとめる前のドラフト'
date: '2013-12-10'
description:
categories: []
tags: [anything, krewFramework]
position: 9999
---

# まとめる前のドラフト

- 考え中のメモは [こちら](/dev-log/thinking-krewfw)

## ポリシーとかスタンス

- **いざとなったら Starling**
    - 基本よくやるゲームの制御は Starling 意識しないで使えるインタフェースにはしておく
    - とはいえ Starling まわりのソフトウェア資産は充実してるので使わない手はない
        - Starling の Extension とか、UI 作るときの Feathers とか
        - ってか Starling ならまあ Feathers 使いたいよね
    - KrewActor は starling.display.Sprite のサブクラスなので Starling まわりのオブジェクトを
      addChild したりできる
    - ただし自分で addChild すると krewFramework が自動的に dispose を呼んでくれなくなる
        - addDisplayObject() を通して addChild してもらう、
          そうでなければ自分で後始末つけてねというルールにする

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

## GameDirector を作る

## Scene を作る

### あなたが override できる KrewScene のハンドラ一覧

<table class="mystyle">
    <tr class="head">
        <td> 関数名 </td>
        <td> できること </td>
        <td> 実装すべきこと </td>
    </tr>
    <tr class="color1">
        <td class="left"> getRequiredAssets </td>
        <td> そのシーンに必要なアセットを定義できる。ここで指定するとシーン初期化時に自動で読み込んでくれる </td>
        <td> アセットのファイル名の配列を返す </td>
    </tr>
    <tr class="color2">
        <td class="left"> getLayerList </td>
        <td> ゲーム画面のレイヤー構造（表示の前後関係や時間軸を適用させるグループ）を定義できる </td>
        <td> レイヤー名の文字列の配列を返す。先頭の要素が最も奥に表示される </td>
    </tr>
    <tr class="color1">
        <td class="left"> getCollisionGroups </td>
        <td> 衝突判定を行いたい者を放り込むためのグループを定義できる </td>
        <td> グループ名と衝突判定相手のグループを定義するための、配列の配列を返す </td>
    </tr>
    <tr class="color2">
        <td class="left"> initLoadingView </td>
        <td> ローディング画面を作れる </td>
        <td> 画面を構成するための Actor をセットする </td>
    </tr>
    <tr class="color1">
        <td class="left"> onLoadProgress </td>
        <td> ローディングの最中の処理を定義できる </td>
        <td> 引数にロードの進捗率が来るので、それを使って何かやる。
             このハンドリングは Actor がシステムイベントを listen することでも実現できる </td>
    </tr>
    <tr class="color2">
        <td class="left"> onLoadCpmlete </td>
        <td> ロード完了時の処理を定義できる </td>
        <td> やりたい処理を書く </td>
    </tr>
    <tr class="color1">
        <td class="left"> initAfterLoad </td>
        <td> アセット読み込み完了後の、シーンの本命の初期化処理を定義できる </td>
        <td> シーンの冒頭で必要な Actor のセットや、イベントの listen を行う </td>
    </tr>
    <tr class="color2">
        <td class="left"> getDefaultNextScene </td>
        <td> 次のシーンの行き先を定義できる </td>
        <td> 次のシーンのインスタンスを返す。exit() を呼んだ場合、ここで返しているシーンに自動的に遷移する </td>
    </tr>
</table>

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




<br/><br/><br/><br/><br/><br/>

