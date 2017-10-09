---
title: 'ソフトウェア一般'
date: '2017-09-19'
description:
categories: []
tags: [anything, Programming, Software]
position: 2
---

# Software Enginnering

## 一般教養

### 用語 / 頭字語系

- 参考：[コンピュータ略語一覧](http://ja.wikipedia.org/wiki/%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%82%BF%E7%95%A5%E8%AA%9E%E4%B8%80%E8%A6%A7)

___

- [ACID 特性](http://ja.wikipedia.org/wiki/ACID_(%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%82%BF%E7%A7%91%E5%AD%A6)
    - トランザクション処理の信頼性を保証する 4 つの性質
- [CRUD](http://ja.wikipedia.org/wiki/CRUD)
    - Create, Read, Update, Delete

### 法則系

- [KISS の原則](http://ja.wikipedia.org/wiki/KISS%E3%81%AE%E5%8E%9F%E5%89%87)
    - Keep it simple, stupid / シンプルに保てアホ
- [YAGNI](http://ja.wikipedia.org/wiki/YAGNI)
    - You ain't gonna need it / そんなの必要ないって（必要になるまでやるな）
- [DRY原則](http://ja.wikipedia.org/wiki/Don't_repeat_yourself)
    - Don't repeat yourself / 繰り返しを避けよ

____

- [何かのときにすっと出したい、プログラミングに関する法則・原則一覧 - Qiita](http://qiita.com/hirokidaichi/items/d6c473d8011bd9330e63)
    - **デメテルの法則**（最小知識の原則）
    - **ヴィルトの法則**（ソフトウェアはハードウェアが高速化するより速く低速化する）
        - ムーアの法則：ハードの性能 18 ヶ月 で 2 倍
        - ゲイツの法則：ソフトの速度 18 ヶ月 で半分
    - **ブルックスの法則**
        - 遅れているプロジェクトへの要員追加は、プロジェクトをさらに遅らせる
        - 9人の妊婦を集めても、1ヶ月で赤ちゃんを出産することはできない
    - **コンウェイの法則**（組織構造がシステム設計に影響を与える）
    - **ホフスタッターの法則**
        - 常に予測以上の時間がかかる（ホフスタッターの法則を計算に入れても）
    - **驚き最小の原則**
        - どちらかで悩んだら、よりユーザやプログラマが驚かない方を選ぼう
    - **ボーイスカウトの規則**
        - 来たときよりも美しく
- [ハンロンの剃刀 - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%8F%E3%83%B3%E3%83%AD%E3%83%B3%E3%81%AE%E5%89%83%E5%88%80)
    - 無能で十分説明されることに悪意を見出すな
    - 陰謀論より失敗論

___

- [アムダールの法則](http://ja.wikipedia.org/wiki/%E3%82%A2%E3%83%A0%E3%83%80%E3%83%BC%E3%83%AB%E3%81%AE%E6%B3%95%E5%89%87)
    - あるプログラムの並列化による速度の向上は、プログラムの逐次処理部分によって制限される
    - （並列化できない部分の処理が n 時間かかるなら、全体をいくら並列化しても n 時間より速くはできない）

### 設計の指針

- [設定より規約](http://ja.wikipedia.org/wiki/%E8%A8%AD%E5%AE%9A%E3%82%88%E3%82%8A%E8%A6%8F%E7%B4%84)
    - 規約を設けることで設定やパラメータの指定を減らせる
    - もともとの意味は「開発者はシステムの慣例に従わない部分だけを指定する」
        - こうすれば柔軟性も損なわれない

### SOLID原則

- [Single responsibility principle](http://en.wikipedia.org/wiki/Single_responsibility_principle)
    - 単一責任の原則
- [開放/閉鎖原則](http://ja.wikipedia.org/wiki/%E9%96%8B%E6%94%BE/%E9%96%89%E9%8E%96%E5%8E%9F%E5%89%87)
    - オープン・クローズドの原則 (OCP : Open-Closed Principle)
    - クラスは拡張に対しては open で、修正に対しては closed であるべき
    - 振る舞いを追加可能であり、振る舞いの追加で既存コードは影響を受けないということ
- [リスコフの置換原則](http://ja.wikipedia.org/wiki/%E3%83%AA%E3%82%B9%E3%82%B3%E3%83%95%E3%81%AE%E7%BD%AE%E6%8F%9B%E5%8E%9F%E5%89%87)
    - LSP : Liskov Substitution Principle
    - コード中である基本クラスが使われている場所は、そのどんな派生クラスでも置換可能であるべき
- [インターフェイス分離の原則（ISP）](http://d.hatena.ne.jp/asakichy/20090129/1233236193)
- [Dependency inversion principle](http://en.wikipedia.org/wiki/Dependency_inversion_principle)
    - 依存関係逆転の法則
    - 上位モジュールは下位モジュールに依存してはならない。どちらも抽象に依存すべき
        - 参照を抽象クラス / インタフェースで持つ（具象クラスを参照しない）
        - 具象クラスを継承しない
        - 基本クラスで実装済みのメソッドをオーバライドしない

#### 参考

- [DIP は間違っている - tech.cm55.com](http://tech.cm55.com/wiki/Designs/DIP)

### 性質

- [直行性](http://ja.wikipedia.org/wiki/%E7%9B%B4%E4%BA%A4%E6%80%A7_(%E6%83%85%E5%A0%B1%E7%A7%91%E5%AD%A6)
    - 機能ごとに独立性が高い（依存関係が小さい）こと
- [参照透過性](http://ja.wikipedia.org/wiki/%E5%8F%82%E7%85%A7%E9%80%8F%E9%81%8E%E6%80%A7)
    - 式（関数）の値が文脈によらず一意に定まること / 副作用を持たないこと
    - これがあるとテストしやすく、事故（バグ）が起こりにくい

### 尺度

- [凝集度](http://ja.wikipedia.org/wiki/%E5%87%9D%E9%9B%86%E5%BA%A6)
    - 高いほうがよい。コードが関心ごとや責任範囲の観点でまとまっているか
- [結合度](http://ja.wikipedia.org/wiki/%E7%B5%90%E5%90%88%E5%BA%A6)
    - 低いほうがよい。結合度が高いとは、依存が広範囲に渡っている状態。読みにくく、事故りやすくなる


### テスト

- [ソフトウェアテスト - Wikipedia](http://ja.wikipedia.org/wiki/%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E3%83%86%E3%82%B9%E3%83%88)

#### キーワード

- 正常系、異常系、エッジケース
- カバレッジ
- αテスト、βテスト
- Feature Complete, Release Candidate
- 単体テスト、結合テスト、システムテスト、受け入れテスト、スモークテスト
- ドライバ、スタブ
- ホワイトボックステスト、ブラックボックステスト

### エンジニアが使う言葉 / 慣用句

- [Boilerplate code](http://en.wikipedia.org/wiki/Boilerplate_code)
    - 自明だが省略できないお決まりのコード片

## 教訓系読み物

- [ArticleS.TimOttinger.ApologizeIncode](http://butunclebob.com/ArticleS.TimOttinger.ApologizeIncode)
    - コードのコメントは謝罪である

## あれ何だっけシリーズ

### 配列の操作

```
 unshift -> [][][] <- push  // 足すやつ
   shift <- [][][] -> pop   // 出すやつ
```

### 何とか互換

- [互換性 - Wikipedia](https://ja.wikipedia.org/wiki/%E4%BA%92%E6%8F%9B%E6%80%A7)

{{# table}}
  -
    - 用語
    - 英語
    - 意味
    - 例
  -
    - 上位互換
    - Upper compatibility
    - 上位グレードの製品が下位の機能も有する
    - Pro 版は Lite 版の全ての機能を含む
  -
    - 下位互換
    - Lower compatibility
    - 下位グレードの製品でも上位機能（の一部）を有する
    - ゲームボーイカラーのゲームは GB でも（色は出ないが）動く
  -
    - 前方互換
    - Forward compatibility
    - 新しいシステムの規格を古いシステムでも使える
    - Excel 2016 で作成したデータが昔の Excel 2013 でも開ける
  -
    - 後方互換
    - Backward compatibility
    - 古いシステムの規格を新しいシステムが使える
    - ・Excel 2013 のデータは Excel 2016 でも開ける<br>・PS のゲームが PS2 で動く
{{/ table}}

- 一般的なのは上位互換と後方互換

<br/>

