---
title: '04.最初に知るべきこと'
date: '2015-08-16'
description:
categories: []
tags: [anything, GameDevStudyGuide]
position: 4
---

# 4. 最初に知るべきこと
<p class="created-at">Updated at: 2015-08-16</p>

## すべてはトレードオフ

**君は完璧なゲームを作ることができない。** 何故なら完璧なゲームなど存在しないからだ。
世の中にはリッチな大作アクションが好きな人もいれば、シンプルなパズルゲームが好きな人もいる。
大衆にウケるようなものを目指すと、売れはするが、全体的に可もなく不可もなくといった仕上がりにはなりがちだ。
逆に特定のターゲットに向けてトガった作品を作れば、一部の人の心を大きく動かすことはできるが、
誰にでもすすめられるようなものにはならないだろう。

何を当たり前のことを、と思うかも知れない。だが当たり前のことを敢えて言語化することは無意味じゃない。
同じような話で、**あらゆる技術分野をマスターすることは、人間に与えられた有限の時間では不可能だ。**
何を、どういう順番で、どれくらいの時間を使って勉強していくかは、君が選ぶんだ。

仕事においても大小様々なトレードオフの判断が求められる。
品質・コスト・納期の頭文字をとった
[QCD](https://en.wikipedia.org/wiki/Quality,_cost,_delivery)
なんかは代表的な例だ。
普段のコーディングにおいても、アルゴリズムを実装するとなれば CPU とメモリが天秤にかけられる場面は多い。
（参考：[時間と空間のトレードオフ](https://ja.wikipedia.org/wiki/%E6%99%82%E9%96%93%E3%81%A8%E7%A9%BA%E9%96%93%E3%81%AE%E3%83%88%E3%83%AC%E3%83%BC%E3%83%89%E3%82%AA%E3%83%95)）

トレードオフが避けられないのはわかった。重要なのは、何かを選択した時に、
**何故それを選択したのかを説明できるようにしておく** ことだ。
場合によっては「時間をかければもっと完璧にできるけど、費用対効果が悪いから、今回はこれでいく」
みたいな選択が正解になることもある。

<div class="key-idea">
<p class="caption">Key Idea:</p>
<p>仕方なくそうするのと、分かっててそれを選んでいるのとでは、大きく違う。</p>
</div>

費用対効果、優先度、緊急度、こういったキーワードを手に、トレードオフと向き合おう。

<div class="hint">
<p class="caption">Hint:</p>
<p>たくさんあるトレードオフの中で、その時最適なものを選んでいくことが、
   エンジニアリングの仕事であるとも言える。</p>
</div>

## 抽象化を目指そう

プログラミングを勉強していると、よく **抽象化** って言葉が出てくると思う。
実際、プログラマの武器でありプログラミングの本質のひとつは抽象化であると僕は思う。
[デザインパターン](https://ja.wikipedia.org/wiki/%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3_(%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2)
なんかは分かりやすい好例だ。

最初のうちは特定の技術用語（オブジェクト指向だとか、OpenGL だとか）
だったり、具体的な実装（Unity でアレをどう動かすのだとか）に目が行ってしまうと思うけど、
慣れてきたら「これは何を解決したくてやっているのか」
みたいな **本質的な問題** を考えてみてほしい。
そうして「こういう問題に対して、こういうパターンで解決している」という具合に
**具体的な言葉を省いた** 大枠で考えられるようになったら、そこで経験したパターンは君の経験値になる。
同じような問題に出くわしたときに、同じように対処できるようになるだろう。

<div class="key-idea">
<p class="caption">Key Idea:</p>
<p>本質を見抜くと、抽象化できる。</p>
<p>抽象化して捉えられると、応用ができる。</p>
</div>

達人がすごいのは、こうした応用のパターンをいくつも持っていて、
それを頭で考えずにスッと引き出せるからだ。
「具体的」な言語の文法やツールのコマンドを覚えるのも、
最後には抽象的な知識を得るためのステップだと考えよう。
君が使っている言語やツールは、5 年後には廃れて無くなってしまっているかもしれない。
だがそこで抽象的な知識を得ていたなら、それは新しい環境でも活かせるだろう。

## 参考文献

### 達人プログラマー

<div class="azlink-box">
  <div class="azlink-image" style="float:left">
    <a href="http://www.amazon.co.jp/exec/obidos/ASIN/4894712741/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank">
      <img src="http://ecx.images-amazon.com/images/I/41HTQ8ZP3AL._SL160_.jpg" alt="達人プログラマー ―システム開発の職人から名匠への道" style="border:none" />
    </a>
  </div>
  <div class="azlink-info" style="float:left;margin-left:15px;line-height:120%">
    <div class="azlink-name" style="margin-bottom:10px;line-height:120%">
      <a href="http://www.amazon.co.jp/exec/obidos/ASIN/4894712741/tkoreshiki-22/ref=nosim/" name="azlinklink" target="_blank">
        達人プログラマー ―システム開発の職人から名匠への道
      </a>
    <div class="azlink-powered-date" style="font-size:7pt;margin-top:5px;font-family:verdana;line-height:120%">
      posted at 2015.8.16
    </div>
  </div>
  <div class="azlink-detail">
    アンドリュー ハント,デビッド トーマス,Andrew Hunt,David Thomas,村上 雅章<br />
    ピアソンエデュケーション<br />
  </div>
  <div class="azlink-link" style="margin-top:5px">
    <a href="http://www.amazon.co.jp/exec/obidos/ASIN/4894712741/tkoreshiki-22/ref=nosim/" target="_blank">
      Amazon.co.jp で詳細を見る
    </a>
  </div>
</div>
<div class="azlink-footer" style="clear:left"></div></div>

2000 年の出版でもはや古典となってしまった感もあるが、広く読まれてきたであろう名著。
残念ながら 2014 年に絶版となってしまったようだが、もし手に取ることがあれば読んでおいて損はない。

あらゆる二重化を避けよ、という **DRY原則** を始め、
ソフトウェア開発における考え方の基本がまとめられている。



