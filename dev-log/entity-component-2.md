---
title: 'Component 指向 (2)'
date: '2016-02-24'
description:
categories: []
tags: [anything, tartFramework]
position: 113.2
---

# Component 指向のフレームワークを考える (2)

Updated at: 2016-02-24

## Entity 生み出す処理をどう書きたいか

### 要件

原理的にはこう：

    // 擬似コード
    var playerEntity:Entity = new Entity()
        .attach(new Transform(position, scale, rotation))
        .attach(new View2D(displayObject, offset))
        .attach(new Collision(CollisionType.SPHERE, radius, offset))
        .attach(new Physics(params))
        .attach(new Tween(...))
        .attach(new PlayerBehavior(...))  // * Script Component
        .attach(new LifeBehavior(...));

    engine.addEntity(playerEntity);

- AS3 なので ECS のメリットのひとつである **連続したメモリ領域へのアクセスでキャッシュミスを減らす**
  みたいなことはこの際あんまり考えない
    - 色々実験してみたけどあんまり頑張っても意味なさそうだったので
- ただし new は極力減らしたい
    - AS3 は結構 instantiation のコストでかいし
    - Entity, インスタンス数の多い Component, よく出てくる Vector3D などは pooling したい
- Pool や ResourceManager などのインスタンスにアクセスする必要があるので
  static な Factory を作ることはできない

____

ということで、実際にはもっと色々やらなきゃいけない事情がある：

    var transform:Transform = componentPool.get(Transform) as Transform;
    var position:Vector3D   = vectorPool.get();
    transform.init(position, scale, rotation);

    var view2D:View2D = componentPool.get(View2D) as View2D;
    var image:Image = resourceManager.getImage2D('asset_name');
    view2D.displayObject = image;

    ...

    var playerEntity:Entity = entityPool.get().attachComponents(
        transform, view2D, collision, ...
    );
    engine.addEntity(playerEntity);

    // 解放時に pool に返却する処理も要る

愚直に書くと見通しが悪い。

- attach の部分は使う Component のクラスだけ列挙するくらいにしたい
    - pool からの取得と返却はフレームワークレイヤーでよしなにやってもらいたい
- もろもろの Component の値の初期化は Script Component 的なやつの中に書きたい
- そして createEntity() する側からパラメータ指定できなければならない

### Script Component

- 純粋な ECS の、全てのロジックを System レイヤーにまとめるのはゲームが複雑になると読みにくい
    - RenderSystem や ParticleSystem みたいなゲームに依存しない基盤っぽいやつは良い
    - Player や Enemy の処理みたいなのは System と呼ぶにはユニークでローカルすぎる
    - そういうのは ScriptComponent として扱う（結局 Unity のノリになる）
    - ScriptComponent にはロジックや基礎 Component への操作を書くことを許す
    - こいつが OOP なゲームコーディングにおける Game Obejct 的な存在になる
    - Player を作ろうと思ったら必要な Component を集めて PlayerScript を書くという発想にする

#### Entity 生み出す側の処理

    {
        // 希少な Game Object ならここは new していい
        engine.createEntityFromScript(new PlayerScript(x, y, avatar));

        // ザコ敵みたいに数の多いやつなら pooling
        engine.createEntityFromScript(playerPool.get().init(x, y, avatar));
    }

#### フレームワークのユーザ（ゲーム開発者）が書くクラス

    // 最終的には Script じゃなくて Actor みたいな名前つけると思うけど意味的には
    public class PlayerScript extends ScriptComponent {

        // 自分に必要な Component リスト
        public function recipe():Vector.<Component> {
            return [
                PlayerScript, Transform, View2D, Collision, ...
                // ↑ 自身は省略してもいいか…
            ];
        }

        /**
         * この辺は基底クラスでやっておくことで楽をする
         *     _transform = getComponent(Transform) as Transform;
         *     _view2D    = getComponent(View2D) as View2D;
         *     _collision = getComponent(Collision) as Collision;
         */

        // constructor
        public function PlayerScript(x:Number, y:Number, avatar:Image) {
            // Component 群の中身の初期化
            // （関数の登録で処理を Entity 組み立て後に遅延させる）
            initAfterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
                _view2D.displayObject = avatar;
            });
        }

        public function awake():void { ... }

        public function update(deltaTime:Number):void { ... }

    }

#### フレームワークレイヤーがやること

    public class Engine {

        public function createEntity(coreScript:ScriptComponent):void {
            var entity:Entity = entityPool.get();
            var components:Vector.<Component> = coreScript.recipe();
            entity.attachComponents(components);
            ...
        }

    }


