---
title: 'tart framework'
date: '2016-02-25'
description:
categories: []
tags: [anything, tartFramework]
position: 113.3
---

# tart framework

Updated at: 2016-02-25

krewFramework の反省を活かした新しい俺俺フレームワークの設計について考える際のメモ

## スコープの管理

- Entity と Resource の生存管理として、Scene スコープと Scene を子に持つ Chapter スコープを用意
- Chapter は Chapter か Scene を複数持つ（Scene が Leaf の Composite）

```
// イメージ
"Global Chapter"
    - Title Scene
    - "NonBattle Chapter"  // 例えばグローバルメニューの Entity スコープ
        - "Homebase Chapter"
            - Room Scene
            - Shop Scene
        - "Field Chapter"
            - WorldList Scene
            - LevelMap Scene
    - "Battle Chapter"
        - Battle Scene
            // - Intro State
            // - Main State
            // - Result State
```

- 何も指定しなければ、デフォルトでは Global Chapter が 1 個あり、
  そこに全ての Scene が足されるようにする
- 関連する Scene をまとめたスコープを作りたくなったときに
  後付けで Chapter を定義できるようにする（キャッシュ目的を想定）

### Chapter と Scene はどう違うのか？

- 実質やることは似てるが、大域スコープを分かりやすくするためにわざわざ Chapter という別名をつける
    - Scene が子 Scene を持つ形にはしない
- Chapter には遷移できない
    - 遷移の概念は Scene to Scene のみ

### どこからでも呼び出したい系 Scene をどうするか

- 例えばあらゆる画面から開き得るゲームオプション画面など
- レアケースだけど Field から Shop 行って戻ってきたいんだよね、とか
    - でもレアケースだから最初から Shop のリソース読み込んでおきたくはない、みたいな
- （基本的に上記のようなツリー構造は横断的関心事が出てくると破綻する）

### Scene の履歴管理をどうするか

- 例えばキャラクター編成画面
    - 割と Scene っぽい大掛かりなものだが、複数から呼び出される系
        - ホームメニュー → 編成 → Back でホーム
        - 出撃前確認 → 編成 → Back で出撃前
    - 2 段階以上階層をもぐる、なんてこともありえる
    - 解決策は基本、**Scene を stack させるか、階層型の SceneState を持たせるか**のどちらか
    - 複数 Chapter に同じ Scene を置くのは Scene 遷移時に
      どちらの Chapter を処理したらいいか分からないのでダメ

## 結局

- Scene の push はやらない（アクティブな Scene は常に 1 つ）
- Scene の履歴管理もフレームワークレイヤーでは用意しない（`backScene()` とかやらない）
    - 背景を保持しておきたいもの、push/pop の概念が必要なものは全て Modal エンティティとして扱い、
      Scene に置いた ModalStack エンティティに制御してもらう
- Scene 内の状態遷移は HFSM エンティティが頑張る

## スコープへの読み込みのパターン

- **Resource**
    - Chapter に入る際、Chapter スコープに読み込む（Chapter を出るときに自動解放）
    - Scene に入る際、Scene スコープに読み込む（Scene を出るときに自動解放）
- **Entity**
    - Chapter に入る際、Chapter スコープに読み込む（Chapter を出るときに自動破棄）
    - Scene に入る際、Scene スコープに読み込む（Scene を出るときに自動破棄）
    - SceneState のスコープは作らない
        - State からは Scene に投げ込む
        - 解放処理は State 抜けるときハンドラに自分で書く
        - （フェードしてから破棄とかやるだろうし、即座に破棄されても困るだろう）

____

- ※ 総じて、Scene から上位の Chapter スコープに投げ込むようなことは、ややこしくなるのでやらない
    - ある Scene のタイミングで Resource を読むが、それは複数 Scene でキャッシュしたい、みたいな場合は？
        - Chapter に「自分の Chapter 内の特定の Scene に初めて入ったハンドラ」を書けるようにしておけばよい
        - 何にしてもレアケースだろう
    - ある State に初めて遷移するタイミングでリソース読み込めばいいけど、
      一度開いたら Chapter 抜けるまではキャッシュしておいてほしい、みたいな場合は？
        - Scene スコープでお茶を濁せないものか…

## Scene 遷移時の処理の流れ

#### Entity に attach されたロジックから、遷移のリクエストを送る
- 然るべきフェーズで tart がハンドリング

#### Exit 処理
- **Scene の解放処理**
    - Scene :: onExitAsync （もし非同期の解放処理を挟みたい場合）
    - Scene :: onExit （同期でよい解放処理）
    - Scene :: _disposeResource （tart が呼ぶ）
      <br/><br/>
- 〜 もしも今いた Chapter を出る場合 〜
    - **Chapter の解放処理**
        - Chapter :: onExitAsync
        - Chapter :: onExit
        - Chapter :: _disposeResource

#### Enter 処理
- 〜 もしも新しい Chapter に入る場合 〜
    - **遷移先 Chapter のロード処理**
        - Chapter :: beforeLoadResource
        - Chapter :: _loadResourceAsync
        - Chapter :: onEnterAsync
        - Chapter :: onEnter
          <br/><br/>
- **遷移先 Scene のロード処理**
    - Scene :: beforeLoadResource
    - Scene :: _loadResourceAsync
    - Scene :: onEnterAsync
    - Scene :: onEnter

#### ネーミング案

> 【Enter 処理】
>
> - awake
> - (_loadResourceAsync)
> - initAsync
> - init

____

> 【Exit 処理】
>
> - disposeAsync
> - dispose
> - （_disposeResource）

- disposeAsync は不要な気がする

## Scene クラス

### 要件の整理

- Scene には基本、必要なものを宣言的に書くだけにしたい
    - Scene スコープに読み込みたいリソース一覧や、初めに置く Entity 一覧など
- だが実際のところ、現実的な規模のゲームを作ろうとすると
  Scene の冒頭にちゃんとした初期化フェーズが必要だったりする
    - 最初の Entity と言われても管理者 Entity くらいしか置けない
    - 何故なら Entity の初期化のためにレベルデータの読み込みだったり、
      処理の順序立てが必要になるから
- そのへんを onEnterAsync の時点で済ませるか、SceneState でやるのか？
    - まあ FSM な Entity を最初に置くのが一番構造的にシンプルで汎用性高いか

____

- Scene に次の Scene を書くべきか？ 遷移の関心事からは独立させるべきか？
    - 履歴管理をやりたいかどうかにもよる
    - 例えば OptionScene はどこから呼ばれたかは気にせず、仕事が終わったら前の Scene に戻るとか
    - いや汎用のポップアップ的な概念は State でやった方が扱いやすいという話もある

### こんな風に書きたい

    public class LevelScene extends TartScene {

        private var _levelId:int;

        // コンストラクタは引数とれるようにしないと不便
        public function LevelScene(levelId:int) {
            _levelId = levelId;
        }

        // Scene スコープに読み込みたいアセットのファイル名一覧
        public function assets():Array {
            return [
                 "image/atlas_" + _levelId + ".jpg"
                ,"image/atlas_" + _levelId + ".xml"
                ,"bmp_font/fonts.png"
                ,"bmp_font/fonts.xml"
                ,"sound/se_01.mp3"
                ,"level_data/level_" + _levelId + ".json"
            ];
        }

        // アセットのロード開始前に呼ばれるハンドラ
        public function awake():void {
            spawn(new LoadingIndicator());
        }

        // Scene の最初の時点に必要な Entity 一覧
        public function initialActors():Array {
            return [
                 new Player()
                ,new Ground()
                ,new HeadUpDisplay()
                ,new EnemyGenerator()
                ,new LevelMapFSM()
            ];
        }

    }

## Chapter クラス

- 複数の Scene をまとめた大域スコープを作るためのもの

### こんな風に書きたい

    public class GlobalChapter extends TartChapter {

        public function GlobalChapter() {
            addScenes(
                OptionScene, ...
            );
            addChapters(
                new HomebaseChapter,
                new FieldChapter,
                new BattleChapter,
                ...
            );
        }

        public function assets():Array {
            return [ ... ];
        }

        public function initialActors():Array { ... },

        public function onEnter():void { ... },

        public function onExit():void { ... },

        public function onEnterSceneFirst(scene:TartScene):void { ... }

    }

## SceneState クラス

- 入り組んだ State の遷移を宣言的に書くためのもの
- 定義に書かれている以外の遷移はしないことを保証する
    - （外側から自由に `gotoState("scene_id")` みたいなことはさせない）

### こんな風に書きたい

    public class LevelMapFSM extends TartFSM {

        public function LevelMapFSM() {
            // いつかツールを作ったらそれでこの中身を吐けるようなイメージで
            // ステート定義（階層型）の json を書く
            super({
                {
                    id      : "init_level_phase",
                    enter   : _initLevel,
                    trigger : ["load_complete_event", "next_state_id"],
                    children: [
                        {
                            ...
                        },
                        ...
                    ]
                },
                new PlayPhase(),  // クラスにまとめることもできるように
                new ResultPhase(),
                ...
            });
        }

    }


