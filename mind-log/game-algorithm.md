---
title: 'ゲームのアルゴリズム'
date: '2015-05-03'
description:
categories: []
tags: [anything, Programming, Algorithm]
position: 6.1
---

# ゲームのアルゴリズムあるある

## NP完全・NP困難な例

- [NP困難 - Wikipedia](http://ja.wikipedia.org/wiki/NP%E5%9B%B0%E9%9B%A3)
    - [P (計算複雑性理論) - Wikipedia](http://ja.wikipedia.org/wiki/P_(%E8%A8%88%E7%AE%97%E8%A4%87%E9%9B%91%E6%80%A7%E7%90%86%E8%AB%96))
    - [NP - Wikipedia](http://ja.wikipedia.org/wiki/NP)
- 「非」決定性チューリングマシンで多項式時間で解けるのが NP
- n の 2 乗、みたいなオーダは多項式時間。2 の n 乗、とかは多項式時間でない

### 最適な組み合わせを選ぶ系

- おすすめ装備とか自動で素材選択とか、RPG 系だと割とカジュアルにある
    - 強化の素材選択みたいなやつは **部分和問題** とか **ナップサック問題** の亜種っぽくなる
    - 評価関数が単純に決まるようなもので、ちゃんとやるなら **動的計画法**
    - でもよくできたゲームは最適解が求まらない（トレードオフやジレンマがある）ので、
      ○○重視みたいなモードを決めて **貪欲法** をやるくらいが無難


<br/><br/>

