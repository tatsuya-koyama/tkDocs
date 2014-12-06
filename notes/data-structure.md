---
title: 'Data Structure'
date: '2014-12-06'
description:
categories: []
tags: [anything, Programming, Algorithm]
position: 2
---

# Data Structure

## Heap

- [ヒープ - Wikipedia](http://ja.wikipedia.org/wiki/%E3%83%92%E3%83%BC%E3%83%97)
    - 最大値（or 最小値）を求めるのに適した木構造
    - 最大ヒープなら、ヒープの性質 (heap property) は「親ノードは子ノードより常に大きいか等しい」
    - **優先度付きキュー (priority queue)** の実装としてよく用いられる
        - 任意の順序で入力されるデータ群から、最大（最小）のものを順に取り出すという操作が高速にできる
        - イベントキューとかの実装に向いてるね

___

- 二項ヒープ、フィボナッチヒープなど、バリエーションがたくさんある

## Skip List

- [スキップリスト - Wikipedia](http://ja.wikipedia.org/wiki/%E3%82%B9%E3%82%AD%E3%83%83%E3%83%97%E3%83%AA%E3%82%B9%E3%83%88)
- [Skip list - Wikipedia](http://en.wikipedia.org/wiki/Skip_list)
- [skip list - SlideShare](http://www.slideshare.net/iammutex/skip-list-9238027)

___

- 順序つきの Link List を階層的に持つことで探索を速くする
- 上の階層ほど要素が歯抜けになってる感じ
    - 最下層は全部の要素が入っていて、i の層の要素は i + 1 の層では p ％で存在
    - p の値を変えれば探索時間とメモリ使用量のトレードオフがとれる
    - 最下層が各駅停車だとすると、上の層に上がるにつれて快速、急行、特急になってくイメージ
- **乱択アルゴリズム** を用いることで **平衡 2 分探索木** と同等の効率を得ているわけだね


