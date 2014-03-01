---
title: 'Cookbook'
date: '2014-03-01'
description:
categories: []
tags: [anything, krewFramework, SampleCode]
position: 3001
---

# krewFramework | Cookbook


## Global Layer

{{# flashModal }}
  id   : flashMordal_globalLayer
  title: Global Layer
  swf  : "{{ urls.media }}/swf/krewsample/krew-sample-global-layer.swf"
{{/ flashModal }}

<a href="https://github.com/tatsuya-koyama/krewFramework/tree/master/samples/projects/global_layer/core-src"
   class="btn large-btn clearfix">
  <img class="btn-icon" src="{{urls.media}}/krewfw/GitHub-Mark-64px.png" width="28" height="28" />
  View Full Source Code
</a>

- krewFramework は基本的に Scene スコープで Actor を管理します
- Scene 遷移時、その Scene の Actor は krewFramework が責任を持って全て破棄します
- しかしながら「常時表示され続けるヘッダ」のように Scene をまたいで Actor を存在させたいこともあります
    - その場合には、自動で破棄が行われないグローバルのレイヤーが使えます

#### Core code

- グローバルレイヤーの数と名前は、 Scene ではなく GameDirector で定義します

##### GameDirector.as

    public class GameDirector extends KrewGameDirector {

        public function GameDirector() {
            var firstScene:KrewScene = new BootScene();
            startGame(firstScene);
        }

        // Define global layers at GameDirector class
        protected override function getGlobalLayerList():Array {
            return ['global-back', 'global-front'];
        }
        ...

##### BootScene.as

    // This scene should be called just one time.
    public class BootScene extends KrewScene {

        public override function getLayerList():Array {
            return ['l-back', 'l-ui'];
        }

        public override function initAfterLoad():void {
            ...

            // Add actor to the global layer
            setUpActor('global-back',  new GlobalWalkerGenerator());
            setUpActor('global-front', new GlobalView("This is Global Layer", 0xffff66));

            blackIn(0.5);

            listen(GameEvent.EXIT_SCENE, onSceneTransition);
        }
        ...

- グローバルの Actor は krewFramework のリソース管理の範囲外になるため、
  後で破棄したくなった場合などには自分でハンドリングする必要があります
- 「レイヤー単位でまとめて消す」のでよい場合には、以下のような方法が用意されています

##### SecondScene.as

    public class SecondScene extends KrewScene {
        ...

        protected function onDisposeGlobalBackLayer(args:Object):void {
            // If global actors are no longer needed
            sharedObj.layerManager.killActors("global-back");
        }

- グローバルの Actor にテクスチャなどを持たせる場合は、Scene スコープではなく
  グローバルスコープに読み込んだリソースを指定する必要がありますので、ご注意を

<br/><br/>




