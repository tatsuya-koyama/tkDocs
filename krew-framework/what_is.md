---
title: '何をするものなのか'
date: '2014-03-02'
description:
categories: []
tags: [anything, krewFramework]
position: 3
---

# krewFramework は何をするものなのか

## 概要

krewFramework はゲームの中身を心地よくコーディングするために作られた、
**Actor 指向** の汎用フレームワークです。
どのゲームを作る場合にでも必要になるような処理の基盤を提供します。

複数のオブジェクトが様々なステートを伴って非同期に連携しあう
ビデオゲームという複雑な概念を、枠組みにのっとってリーズナブルに記述できるようにすることが
krewFramework のゴールとなります。


## アーキテクチャ

krewFramework は
[Stage3D](http://www.adobe.com/devnet/flashplayer/stage3d.html)
を用いる
[Adobe AIR](http://www.adobe.com/jp/products/air.html)
/ [Flash](http://www.adobe.com/jp/products/flashplayer.html)
向けのゲームフレームワークです。
概ねワンソースで iOS / Android などのモバイル端末、
Mac / Windows などの PC ブラウザと、主要なプラットフォームに作品を展開できます。

krewFramework は内部で [Starling Framework](http://gamua.com/starling/)
を使用しています。Starling は Stage3D を使って 2D のゲームを作るためのゲームエンジンで、
Adobe が公式でサポートしているオープンソースのプロジェクトです。

<div style="text-align: center;">
  <img class="" src="{{urls.media}}/krewfw/krewfw_architecture.png"
       style="width: 100%; max-width: 893px; margin-bottom: 2.0em;" />
</div>

Adobe AIR / Flash 向けということで、言語は **ActionScript3.0** を使います。
krewFramework の利用者は Starling を知らなくてもゲームを書くことはできますが、
Starling の機能や拡張ライブラリは krewFramework 上でも利用可能です。


## krewFramework を使うことで得られる恩恵

- Scene スコープのリソース管理の簡略化（生成と破棄の自動化）
- Actor のメッセージングを用いた依存性の低い協調動作
- Layer 単位での表示順序の制御
- Layer 単位での、Actor の時間軸の制御
- コマ落ちと処理落ちを切り替える、ゲーム向けの時間軸の制御
- 手軽に書ける Tween やマルチタスキング
- 手軽に書ける BGM / SE 再生
- 簡単な衝突判定
- ビルトインの Actor による、よくやる処理のコーディングの短縮






