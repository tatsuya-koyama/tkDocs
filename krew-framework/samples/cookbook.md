---
title: 'Cookbook'
date: '2014-03-01'
description:
categories: []
tags: [anything, krewFramework, SampleCode]
position: 3001
---

# krewFramework | Cookbook


## Simple Loading Screen

<div style="text-align: center;">
  <img class="photo" src="{{urls.media}}/krewfw/simple-loading-screen.png" />
</div>

    import krewfw.core.KrewScene;
    import krewfw.builtin_actor.display.SimpleLoadingScreen;

    public class LoadScene extends KrewScene {
        ...

        public override function initLoadingView():void {
            setUpActor('layer-name', new SimpleLoadingScreen(0x000000));
        }
        ...

- とりあえず簡易的な表示をするだけでいいなら、そういう Actor があります
- SimpleLoadingScreen を initLoadingView() 内で置くだけで OK です
    - この Actor はロード完了時に自動的に破棄されます



<br/><br/>
## Display Order Management

- ToDo: Documentation


## Collision Detection

- ToDo: Documentation


## Touch Event

- ToDo: Documentation


## Tween

- ToDo: Documentation

## Actor じゃないやつがリソースアクセスしたくなったらどうするの

- ToDo: KrewActorAgent について書く



<br/>


